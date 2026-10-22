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
  LFO_SINE, LFO_TRIANGLE, LFO_SAW_UP, LFO_SAW_DOWN, LFO_SQUARE,
  LFO_RANDOM_HOLD, LFO_RANDOM_SMOOTH, LFO_NUM_SHAPES
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

struct GrainModulation {
  double cycles[kModLfos];     // phase accumulator in cycles (integer part = cycle number)
  float split[kModLfos];       // stereo split in cycles (phase knob / 360)
  uint8_t shape[kModLfos];
  uint8_t unipolar[MOD_NUM_DESTINATIONS][kModLfos];   // per matrix cell: 1 = LFO runs 0..1, 0 = -1..1 (default)
  uint32_t seed[kModLfos];
  float depth[MOD_NUM_DESTINATIONS][kModLfos];   // -1..1 (matrix percent / 100)
  float base[MOD_NUM_DESTINATIONS];              // the knob values the modulation is relative to

  GrainModulation() {
    for (int i = 0; i < kModLfos; ++i) {
      cycles[i] = 0.0; split[i] = 0.0f; shape[i] = 0;
      seed[i] = 0x1234567u * uint32_t(i + 1);
      for (int d = 0; d < MOD_NUM_DESTINATIONS; ++d) { depth[d][i] = 0.0f; unipolar[d][i] = 0; }
    }
    for (int d = 0; d < MOD_NUM_DESTINATIONS; ++d) base[d] = ModDefaultBase(d);
  }

  // LFO i evaluated `offset` cycles away from its current phase.
  inline float Lfo(int i, double offset) const {
    const double x = cycles[i] + offset;
    const double fl = std::floor(x);
    const float f = float(x - fl);
    const int64_t c = int64_t(fl);
    float v;
    switch (shape[i]) {
      case LFO_SINE:     v = std::sin(f * 6.2831853f); break;
      case LFO_TRIANGLE: v = 1.0f - 4.0f * std::fabs(f - 0.5f); break;
      case LFO_SAW_UP:   v = f * 2.0f - 1.0f; break;
      case LFO_SAW_DOWN: v = 1.0f - f * 2.0f; break;
      case LFO_SQUARE:   v = f < 0.5f ? 1.0f : -1.0f; break;
      case LFO_RANDOM_HOLD: v = ModHash(seed[i], c); break;
      default: {
        const float a = ModHash(seed[i], c), b = ModHash(seed[i], c + 1);
        v = a + (b - a) * f * f * (3.0f - 2.0f * f);
      }
    }
    return v;      // always -1..1; a matrix cell may map it to 0..1 (see Offset)
  }

  // Modulation of `dest` (in the destination's own units) at stereo position u.
  //
  // The LFOs add up to m = sum(depth * lfo), roughly -1..+1. The knob is the centre of the swing and
  // the amount is how far the LFO travels, in knob turns: m x the whole range of the knob, so
  // +100% swings +/- one full turn around the knob (two turns peak to peak, clipped at the ends
  // of the range), 50% swings +/- half a turn, and a negative amount flips the LFO upside down.
  inline float Offset(int dest, float u) const {
    float sum = 0.0f;
    for (int i = 0; i < kModLfos; ++i) {
      const float d = depth[dest][i];
      if (d == 0.0f) continue;
      const float v = Lfo(i, double(u) * 0.5 * double(split[i]));
      sum += d * (unipolar[dest][i] ? 0.5f * v + 0.5f : v);
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
