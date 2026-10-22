// Port addition (not part of the original Beads firmware): host-supplied LFO
// modulation that is sampled once per grain.
//
// The host keeps four LFOs running and fills a GrainModulation once per codec
// block. Two layers use it:
//   * block level - the host adds Offset(dest, 0) to every destination's base
//     value (so density, feedback, reverb, dry/wet and delay mode follow too);
//   * grain level - when a grain starts, the player adds only the *difference*
//     between the LFOs at that grain's stereo position and at the centre
//     (GrainDelta), to time / pitch / shape.
//
// A grain's stereo position u runs from -1 (hard left) to +1 (hard right). Each
// LFO has a "split": the left channel samples the LFO split/2 cycles earlier and
// the right split/2 cycles later, so grains panned apart see different LFO
// phases. With split = 0 GrainDelta is exactly 0.
//
// The LFO follows Ableton's Live 12 LFO device: nine shapes (Sine, Up, Down, Triangle, Square,
// Random, Bin, Stray, Glider), a wave-shape curve, steps, jitter, smooth, momentary hold, and
// output = offset + depth * (value - 0.5), all in 0..1. Everything that depends only on the phase
// (shape, curve, steps) is a pure function of it, so a grain can read the LFO at its own stereo
// offset; the time-domain parts (jitter, smooth) are computed once per block by the host and come in
// as `post`, added to every read, and a held LFO returns its held value to every grain.
//
// The random shapes use a private deterministic hash (not stmlib::Random), so
// they never disturb Beads' own random sequence.

#ifndef BEADS_DSP_GRAIN_MODULATION_H_
#define BEADS_DSP_GRAIN_MODULATION_H_

#include <cmath>
#include <cstdint>

namespace beads {

enum { kModLfos = 4 };

enum ModDestination {
  MOD_TIME, MOD_SIZE, MOD_SHAPE, MOD_PITCH,
  MOD_DENSITY, MOD_FEEDBACK, MOD_REVERB, MOD_DRYWET,
  MOD_NUM_DESTINATIONS
};

enum LfoShape {
  LFO_SINE, LFO_UP, LFO_DOWN, LFO_TRIANGLE, LFO_SQUARE,
  LFO_RANDOM, LFO_BIN, LFO_STRAY, LFO_GLIDER, LFO_NUM_SHAPES
};

// The range of each destination (pitch in semitones, everything else 0..1).
inline float ModLo(int dest) { return dest == MOD_PITCH ? -24.0f : 0.0f; }
inline float ModHi(int dest) { return dest == MOD_PITCH ? 24.0f : 1.0f; }
inline float ModDefaultBase(int dest) { return dest == MOD_PITCH ? 0.0f : 0.5f; }

// Deterministic value in [-1, 1) for (seed, cycle number).
inline float ModHash(uint32_t seed, int64_t cycle) {
  uint32_t x = seed + uint32_t(cycle) * 0x9E3779B9u;
  x ^= x >> 16; x *= 0x7feb352du;
  x ^= x >> 15; x *= 0x846ca68bu;
  x ^= x >> 16;
  return float(x >> 8) * (2.0f / 16777216.0f) - 1.0f;
}

// Blackman window, the "wavelet" of the Stray shape (the example uses an 8192-sample buffer).
inline float ModBlackman(float x) {
  return 0.42f - 0.5f * std::cos(6.2831853f * x) + 0.08f * std::cos(12.5663706f * x);
}

// The example's exponent curve: amount -1..1 (x0.95 at the extremes) bends the 0..1 wave.
inline float ModCurve(float x, float amount) {
  if (amount == 0.0f) return x;
  const float a = std::fabs(amount) * 0.0095f * 100.0f;     // amount is the dial / 100, the device scales by 0.0095 per percent
  const float k = 1.0f / (1.0f - a);
  if (amount > 0.0f) return x <= 0.0f ? 0.0f : std::exp(std::log(x) * k);
  return x >= 1.0f ? 1.0f : 1.0f - std::exp(std::log(1.0f - x) * k);
}

struct GrainModulation {
  double cycles[kModLfos];     // phase accumulator in cycles (integer part = cycle number)
  float split[kModLfos];       // stereo split in cycles (phase knob / 360)
  uint8_t shape[kModLfos];
  float wave[kModLfos];        // wave-shape curve, -1..1 (the dial / 100); only for the first five shapes
  uint8_t steps[kModLfos];     // 0 = off, 1..24 levels (not for Square / Random / Bin)
  float offset01[kModLfos];    // centre of the output, 0..1 (0.5 = the dial at 0)
  float depth01[kModLfos];     // 0..1
  float post[kModLfos];        // jitter + smoothing, added to the pure value (set per block by the host)
  uint8_t holding[kModLfos];   // 1 = output frozen at held[]
  float held[kModLfos];        // the held value, before offset / depth scaling
  uint8_t unipolar[MOD_NUM_DESTINATIONS][kModLfos];   // per matrix cell: 1 = LFO runs 0..1, 0 = -1..1 (default)
  uint32_t seed[kModLfos];
  float depth[MOD_NUM_DESTINATIONS][kModLfos];   // -1..1 (matrix percent / 100)
  float base[MOD_NUM_DESTINATIONS];              // the knob values the modulation is relative to

  GrainModulation() {
    for (int i = 0; i < kModLfos; ++i) {
      cycles[i] = 0.0; split[i] = 0.0f; shape[i] = 0; wave[i] = 0.0f; steps[i] = 0;
      offset01[i] = 0.5f; depth01[i] = 1.0f; post[i] = 0.0f; holding[i] = 0; held[i] = 0.5f;
      seed[i] = 0x1234567u * uint32_t(i + 1);
      for (int d = 0; d < MOD_NUM_DESTINATIONS; ++d) { depth[d][i] = 0.0f; unipolar[d][i] = 0; }
    }
    for (int d = 0; d < MOD_NUM_DESTINATIONS; ++d) base[d] = ModDefaultBase(d);
  }

  // The raw shape at phase x (in cycles), 0..1, before curve and steps. Pure function of x.
  inline float RawShape(int i, double x) const {
    const double fl = std::floor(x);
    const float f = float(x - fl);
    const int64_t c = int64_t(fl);
    switch (shape[i]) {
      case LFO_SINE:     return (std::cos(f * 6.2831853f) + 1.0f) * 0.5f;     // starts at the top, like the device
      case LFO_UP:       return f;
      case LFO_DOWN:     return 1.0f - f;
      case LFO_TRIANGLE: { const float t = 2.0f * f; return t <= 1.0f ? t : 2.0f - t; }
      case LFO_SQUARE:   return f > 0.5f ? 1.0f : 0.0f;
      case LFO_RANDOM:   return (ModHash(seed[i], c) + 1.0f) * 0.5f;
      case LFO_BIN:      return ModHash(seed[i], c) > 0.0f ? 1.0f : 0.0f;
      case LFO_STRAY: {
        // Two blackman-windowed noise bursts half a cycle apart, each with a fresh random gain every cycle.
        const float next = f, curr = f < 0.5f ? f + 0.5f : f - 0.5f;
        const int64_t cc = int64_t(std::floor(x + 0.5));
        const float a_next = ModHash(seed[i], c) * 4.0f;
        const float a_curr = ModHash(seed[i] ^ 0xA5A5A5A5u, cc) * 4.0f;
        const float y_next = ModBlackman(next) * a_next * (next * 2.0f - 1.0f);
        const float y_curr = ModBlackman(curr) * a_curr * (curr * 2.0f - 1.0f);
        return 0.5f + 0.5f * std::sin((y_curr + y_next) * 0.5f * 2.3f);
      }
      default: {         // LFO_GLIDER: glides between this cycle's random value and the previous one
        const float a = std::fabs(ModHash(seed[i], c)), b = std::fabs(ModHash(seed[i], c - 1));
        const float drive = 0.5f + 0.5f * std::sin(f * 3.14159265f - 1.57079633f);
        return drive * a + (1.0f - drive) * b;
      }
    }
  }

  // Shape, wave-shape curve and steps at phase x: what is left once the time-domain parts are taken out.
  inline float Shape(int i, double x) const {
    float v = RawShape(i, x);
    const int sh = shape[i];
    if (sh <= LFO_SQUARE && wave[i] != 0.0f) v = ModCurve(v, wave[i]);
    if (steps[i] > 0 && sh != LFO_SQUARE && sh != LFO_RANDOM && sh != LFO_BIN) {
      const float n = float(steps[i]);
      v = std::floor(v * n + 0.5f) / n;
    }
    return v;
  }

  // Output scaling shared by every read: offset + depth * (value - 0.5), clipped to 0..1.
  inline float Scale(int i, float v) const {
    const float o = offset01[i] + depth01[i] * (v - 0.5f);
    return o < 0.0f ? 0.0f : (o > 1.0f ? 1.0f : o);
  }

  // LFO i evaluated `offset` cycles away from its current phase: 0..1.
  inline float Lfo(int i, double offset) const {
    if (holding[i]) return Scale(i, held[i]);
    return Scale(i, Shape(i, cycles[i] + offset) + post[i]);
  }

  // Modulation of `dest` (in the destination's own units) at stereo position u.
  //
  // The LFOs (0..1) are applied per matrix cell, and 100% means the LFO travels the knob's whole range
  // (x the amount). A bipolar cell (+/-) uses lfo - 0.5, so the value swings around the knob, below it as
  // well as above it: with the knob in the middle +100% runs from the bottom to the top of the range
  // (peak to peak = the whole range), +50% from a quarter to three quarters. A unipolar cell (+) uses
  // the LFO as it is, so the value only goes up from the knob and comes back down to it, by up to
  // amount x the range. A negative amount flips the direction in both cases, and the result is clipped
  // at the ends of the range (so off-centre knobs clip). The cells of one destination add up.
  inline float Offset(int dest, float u) const {
    float sum = 0.0f;
    for (int i = 0; i < kModLfos; ++i) {
      const float d = depth[dest][i];
      if (d == 0.0f) continue;
      const float l = Lfo(i, double(u) * 0.5 * double(split[i]));         // 0..1
      sum += d * (unipolar[dest][i] ? l : l - 0.5f);
    }
    return sum * (ModHi(dest) - ModLo(dest));
  }

  // What a grain at stereo position u adds on top of the block-level offset.
  inline float GrainDelta(int dest, float u) const {
    return Offset(dest, u) - Offset(dest, 0.0f);
  }
};

}  // namespace beads

#endif  // BEADS_DSP_GRAIN_MODULATION_H_
