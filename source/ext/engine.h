// Host-rate wrapper around beads::Processor (kept free of Max headers so it
// can be unit-tested offline).
#ifndef BEADS_MAX_ENGINE_H_
#define BEADS_MAX_ENGINE_H_

#include <cstddef>
#include <cstdint>
#include <memory>

namespace beads_max {

enum Input {
  IN_L, IN_R, IN_TIME_CV, IN_SIZE_CV, IN_SHAPE_CV, IN_PITCH_CV, IN_DENSITY_CV,
  IN_SEED, IN_FREEZE, NUM_INPUTS
};

// One of the four built-in LFOs. They are sampled per grain (see
// beads/dsp/grain_modulation.h) and mixed into the destinations by Params::mod.
struct LfoParams {
  long shape = 0;         // 0 sine, 1 triangle, 2 saw up, 3 saw down, 4 square,
                          // 5 random hold, 6 random smooth
  float rate = 1.0f;      // Hz (when not synced)
  long sync = 0;          // 1 = follow the tempo using `div`
  long div = 7;           // 0..17: 1/16T 1/16 1/16. ... 2/1T 2/1 2/1. (7 = 1/4)
  float split_deg = 0.0f; // stereo split: how far apart (degrees of the cycle)
                          // the left and right edges of the stereo field sample the LFO
  long reset = 0;         // a counter: any change restarts the cycle
};

// Modulation destinations, in the order of Params::mod rows.
enum ModDest {
  DEST_TIME, DEST_SIZE, DEST_SHAPE, DEST_PITCH,
  DEST_DENSITY, DEST_FEEDBACK, DEST_REVERB, DEST_DRYWET, NUM_DESTS
};
const int kNumLfos = 4;

struct Params {
  float time = 0.5f, time_amt = 0.0f;
  float size = 0.5f, size_amt = 0.0f;
  float shape = 0.5f, shape_amt = 0.0f;
  float pitch = 0.0f, pitch_amt = 0.0f;  // pitch in semitones
  float density = 0.7f;  // 0.48-0.52 is a dead zone (no internal triggers)
  float feedback = 0.0f, dry_wet = 0.5f, reverb = 0.0f;
  float gain = 1.0f;
  long seed_button = 0;  // 0 off, 1 on, 2 locked
  long freeze = 0;
  long gate_out = 0;

  // LFO modulation.
  LfoParams lfo[kNumLfos];
  long uni[NUM_DESTS][kNumLfos] = {};   // polarity of each matrix cell: 0 = bipolar +/- (default), 1 = unipolar +
  float mod[NUM_DESTS][kNumLfos] = {};  // matrix, percent (-100..100); +100% sweeps
                                        // half the destination's range either side
  float tempo = 120.0f;                 // BPM, for synced LFOs
  float spread = 0.0f;                  // extra random pan width, 0..1 (0 = original Beads)

  // Level control. Overlapping grains of the same material can come out 10-15 dB hotter than the
  // input; the original relied on a fixed 0.9 peak limiter and on the hardware input AGC.
  long wetcap = 1;                      // 1 = hold the wet path to `wetcap_db` above the input level
  float wetcap_db = 3.0f;               // how far above a slow estimate of the input it may go
  long overlap = 0;                     // 1 = stronger overlap scaling (see overlap_amt)
  float overlap_amt = 1.0f;             // 0 = original 1/sqrt(grains playing) .. 1 = 1/(grains playing)
};

// One entry per grain started (granular mode; delay mode has taps, not grains).
struct GrainEvent {
  float time;         // read position 0..1 across the buffer
  float pitch_ratio;  // playback speed ratio (> 0)
  float duration;     // seconds
  float shape;        // 0..1
  float amplitude;
  float pan;          // 0..1, 0.5 = centre
  bool reverse;
};

class Engine {
 public:
  Engine();
  ~Engine();

  // Reconfigures media/mono and the resamplers. Resets the delay buffers.
  // media: 0 dirty tape, 1 clean tape, 2 vintage digital, 3 digital.
  void Setup(double host_sr, int max_vector, int media, bool mono);

  // in[] has NUM_INPUTS entries; unconnected inputs are nullptr.
  // out_trig (optional) gets a 1-sample impulse (1.0) per grain start, time
  // aligned with out_l/out_r and quantised to one codec block (~0.25 ms).
  void Process(const Params& p, const float* const* in, float* out_l,
               float* out_r, size_t n, float* out_trig = nullptr);

  // Drains grain events (any thread; single consumer). Returns the count.
  size_t PopGrains(GrainEvent* out, size_t max);
  bool HasGrains() const;

  // Latest LFO state for displays (any thread): the value seen by the left and
  // right edges of the stereo field, and the centre phase (0..1).
  // `hz` (optional) is the LFO's effective speed in cycles per second: the Rate knob, or the tempo-
  // synced rate, so a display can scale its waveform with it.
  void GetLfo(int i, float* value_l, float* value_r, float* phase, float* hz = nullptr) const;

  double codec_rate() const;
  int latency_samples() const { return latency_; }

 private:
  struct Impl;
  std::unique_ptr<Impl> impl_;
  int latency_ = 0;
};

}  // namespace beads_max

#endif  // BEADS_MAX_ENGINE_H_
