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
};

class Engine {
 public:
  Engine();
  ~Engine();

  // Reconfigures media/mono and the resamplers. Resets the delay buffers.
  // media: 0 dirty tape, 1 clean tape, 2 vintage digital, 3 digital.
  void Setup(double host_sr, int max_vector, int media, bool mono);

  // in[] has NUM_INPUTS entries; unconnected inputs are nullptr.
  void Process(const Params& p, const float* const* in, float* out_l,
               float* out_r, size_t n);

  double codec_rate() const;
  int latency_samples() const { return latency_; }

 private:
  struct Impl;
  std::unique_ptr<Impl> impl_;
  int latency_ = 0;
};

}  // namespace beads_max

#endif  // BEADS_MAX_ENGINE_H_
