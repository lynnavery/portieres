#include "ext/engine.h"

#include <algorithm>
#include <array>
#include <atomic>
#include <cmath>
#include <cstdlib>
#include <cstring>
#include <vector>

#include "beads/dsp/processor.h"
#include "ext/resampler.h"

namespace beads_max {

namespace {
const size_t kMaxBlock = 16;       // >= codec_rate / 4000 for every media
const size_t kCtlRing = 16384;
const int kNumCv = 5;

struct CtlFrame {
  float cv[kNumCv];
  float seed;
  float freeze;
};

const size_t kGrainRing = 1024;     // power of two
const size_t kTrigHist = 16384;     // power of two, codec-rate flag history

inline float Clamp(float x, float lo, float hi) {
  return x < lo ? lo : (x > hi ? hi : x);
}

// Beats per LFO cycle for division index 0..17: 0.25 * 2^(k/3) * {2/3, 1, 1.5}[k%3]
// i.e. 1/16T 1/16 1/16. 1/8T 1/8 1/8. ... 2/1T 2/1 2/1.  (a quarter note = 1 beat)
float DivisionBeats(long k) {
  k = k < 0 ? 0 : (k > 17 ? 17 : k);
  static const float kFactor[3] = { 2.0f / 3.0f, 1.0f, 1.5f };
  return 0.25f * std::ldexp(1.0f, int(k / 3)) * kFactor[k % 3];
}
}  // namespace

struct Engine::Impl : public beads::GrainObserver {
  beads::Processor processor;
  uint8_t* buffer1 = nullptr;
  uint8_t* buffer2 = nullptr;
  uint16_t* reverb_buffer = nullptr;

  Resampler src_in, src_out;
  double host_sr = 48000.0, codec_sr = 48000.0;
  int media = 3;
  bool mono = false;
  bool configured = false;
  bool primed = false;
  size_t block = 12;

  // Control signals are brought to codec rate by accumulate-and-hold.
  std::vector<CtlFrame> ctl = std::vector<CtlFrame>(kCtlRing);
  size_t ctl_r = 0, ctl_w = 0;
  double ctl_phase = 0.0, ctl_step = 1.0;
  CtlFrame ctl_acc, ctl_last;
  int ctl_count = 0;

  std::vector<float> in_l, in_r, out_buf_l, out_buf_r;
  stmlib::GateFlags previous_seed = stmlib::GATE_FLAG_LOW;

  // LFO bank. `gm` is rebuilt from the parameters every codec block and handed to
  // the grain player; it also carries the running phases.
  beads::GrainModulation gm;
  long last_reset[kNumLfos] = { 0, 0, 0, 0 };
  bool lfo_init = false;
  std::atomic<float> ro_l[kNumLfos], ro_r[kNumLfos], ro_phase[kNumLfos];

  size_t ctl_avail() const { return ctl_w - ctl_r; }

  // Grain events: audio thread produces, PopGrains() consumes.
  std::array<GrainEvent, kGrainRing> grains;
  std::atomic<size_t> grain_w{0}, grain_r{0};
  size_t grains_seen = 0;  // running count, used to flag codec blocks

  void OnGrain(const beads::GrainEvent& e) override {
    ++grains_seen;
    const size_t w = grain_w.load(std::memory_order_relaxed);
    if (w - grain_r.load(std::memory_order_acquire) >= kGrainRing) return;
    GrainEvent& g = grains[w & (kGrainRing - 1)];
    g.time = e.time;
    g.pitch_ratio = e.pitch_ratio;
    g.duration = e.duration;
    g.shape = e.shape;
    g.amplitude = e.amplitude;
    g.pan = e.pan;
    g.reverse = e.reverse;
    grain_w.store(w + 1, std::memory_order_release);
  }

  // Codec-rate grain-start flags, kept in step with src_out so the impulse
  // lines up with the audio. Not run through the resampler: a sinc would smear
  // it.
  std::vector<float> trig_hist = std::vector<float>(kTrigHist, 0.0f);
  size_t trig_written = 0;
  double trig_pos = 0.0;
  size_t trig_last = 0;  // last codec index already emitted
};

Engine::Engine() : impl_(new Impl) {
  for (int i = 0; i < kNumLfos; ++i) {
    impl_->ro_l[i] = 0.0f;
    impl_->ro_r[i] = 0.0f;
    impl_->ro_phase[i] = 0.0f;
  }
  impl_->buffer1 = static_cast<uint8_t*>(calloc(512 * 1024, 1));
  impl_->buffer2 = static_cast<uint8_t*>(calloc(256 * 1024, 1));
  impl_->reverb_buffer = static_cast<uint16_t*>(calloc(32768, sizeof(uint16_t)));
  uint8_t* buffers[3] = { impl_->buffer1, impl_->buffer1 + 256 * 1024,
                          impl_->buffer2 };
  impl_->processor.Init(buffers, impl_->reverb_buffer);
  impl_->processor.set_grain_observer(impl_.get());
}

Engine::~Engine() {
  free(impl_->buffer1);
  free(impl_->buffer2);
  free(impl_->reverb_buffer);
}

double Engine::codec_rate() const { return impl_->codec_sr; }

void Engine::Setup(double host_sr, int max_vector, int media, bool mono) {
  Impl& s = *impl_;
  s.media = std::min(3, std::max(0, media));
  s.mono = mono;
  s.host_sr = host_sr;
  s.processor.Configure(beads::Processor::Media(s.media), mono);
  s.codec_sr = s.processor.sample_rate();
  s.block = size_t(s.codec_sr / 4000.0 + 0.5);
  s.src_in.Init(host_sr, s.codec_sr);
  s.src_out.Init(s.codec_sr, host_sr);

  s.ctl_r = s.ctl_w = 0;
  s.ctl_phase = 0.0;
  s.ctl_step = s.codec_sr / host_sr;
  memset(&s.ctl_acc, 0, sizeof(s.ctl_acc));
  memset(&s.ctl_last, 0, sizeof(s.ctl_last));
  s.ctl_count = 0;
  s.previous_seed = stmlib::GATE_FLAG_LOW;
  s.lfo_init = false;   // adopt the current reset counters without restarting the LFOs

  const size_t n = size_t(std::max(max_vector, 1)) + 64;
  s.in_l.assign(n + 4 * kMaxBlock, 0.0f);
  s.in_r.assign(n + 4 * kMaxBlock, 0.0f);
  s.out_buf_l.assign(n + 4 * kMaxBlock, 0.0f);
  s.out_buf_r.assign(n + 4 * kMaxBlock, 0.0f);

  // Prime the output with silence so steady-state pulls never underrun: the
  // pipeline works in codec-rate blocks, so it runs up to one block behind
  // the host vector.
  const size_t prime = size_t(std::ceil(max_vector * s.ctl_step)) +
                       2 * s.block + 8;
  for (size_t i = 0; i < prime; ++i) s.src_out.PushOne(0.0f, 0.0f);
  std::fill(s.trig_hist.begin(), s.trig_hist.end(), 0.0f);
  s.trig_written = prime;  // same priming as src_out
  s.trig_pos = 0.0;
  s.trig_last = 0;
  s.grain_r.store(s.grain_w.load(std::memory_order_acquire),
                  std::memory_order_release);
  s.primed = true;
  s.configured = true;
  latency_ = int(std::ceil((double(prime) / s.ctl_step) +
                           s.src_in.latency_in_samples() +
                           s.src_out.latency_in_samples() / s.ctl_step));
}

bool Engine::HasGrains() const {
  const Impl& s = *impl_;
  return s.grain_r.load(std::memory_order_relaxed) !=
         s.grain_w.load(std::memory_order_acquire);
}

void Engine::GetLfo(int i, float* value_l, float* value_r, float* phase) const {
  const Impl& s = *impl_;
  if (i < 0 || i >= kNumLfos) {
    if (value_l) *value_l = 0.0f;
    if (value_r) *value_r = 0.0f;
    if (phase) *phase = 0.0f;
    return;
  }
  if (value_l) *value_l = s.ro_l[i].load(std::memory_order_relaxed);
  if (value_r) *value_r = s.ro_r[i].load(std::memory_order_relaxed);
  if (phase) *phase = s.ro_phase[i].load(std::memory_order_relaxed);
}

size_t Engine::PopGrains(GrainEvent* out, size_t max) {
  Impl& s = *impl_;
  size_t r = s.grain_r.load(std::memory_order_relaxed);
  const size_t w = s.grain_w.load(std::memory_order_acquire);
  size_t k = 0;
  while (r != w && k < max) out[k++] = s.grains[r++ & (kGrainRing - 1)];
  s.grain_r.store(r, std::memory_order_release);
  return k;
}

void Engine::Process(const Params& p, const float* const* in, float* out_l,
                     float* out_r, size_t n, float* out_trig) {
  Impl& s = *impl_;
  if (!s.configured) {
    std::fill(out_l, out_l + n, 0.0f);
    std::fill(out_r, out_r + n, 0.0f);
    if (out_trig) std::fill(out_trig, out_trig + n, 0.0f);
    return;
  }

  // Process in slices so internal scratch buffers stay small.
  const size_t kSlice = s.in_l.size() - 4 * kMaxBlock;
  for (size_t base = 0; base < n; base += kSlice) {
    const size_t m = std::min(kSlice, n - base);
    const float* L = in[IN_L] ? in[IN_L] + base : nullptr;
    const float* R = in[IN_R] ? in[IN_R] + base : L;

    // Audio into the codec-rate domain.
    for (size_t i = 0; i < m; ++i) {
      s.in_l[i] = L ? L[i] : 0.0f;
      s.in_r[i] = R ? R[i] : 0.0f;
    }
    s.src_in.Push(s.in_l.data(), s.in_r.data(), m);

    // Control signals (accumulate-and-hold to codec rate).
    for (size_t i = 0; i < m; ++i) {
      CtlFrame cur;
      for (int c = 0; c < kNumCv; ++c) {
        const float* sig = in[IN_TIME_CV + c];
        cur.cv[c] = sig ? sig[base + i] : 0.0f;
      }
      cur.seed = in[IN_SEED] ? in[IN_SEED][base + i] : 0.0f;
      cur.freeze = in[IN_FREEZE] ? in[IN_FREEZE][base + i] : 0.0f;
      // Mean for CV, max for gates so short pulses survive downsampling.
      for (int c = 0; c < kNumCv; ++c) s.ctl_acc.cv[c] += cur.cv[c];
      s.ctl_acc.seed = std::max(s.ctl_acc.seed, cur.seed);
      s.ctl_acc.freeze = std::max(s.ctl_acc.freeze, cur.freeze);
      ++s.ctl_count;
      s.ctl_phase += s.ctl_step;
      while (s.ctl_phase >= 1.0) {
        s.ctl_phase -= 1.0;
        CtlFrame out = s.ctl_acc;
        for (int c = 0; c < kNumCv; ++c) out.cv[c] /= float(s.ctl_count);
        s.ctl_last = out;
        if (s.ctl_avail() < kCtlRing) {
          s.ctl[s.ctl_w % kCtlRing] = out;
          ++s.ctl_w;
        }
        // Upsampling case: following frames within this host sample hold.
        memset(&s.ctl_acc, 0, sizeof(s.ctl_acc));
        s.ctl_count = 0;
        if (s.ctl_phase >= 1.0) {
          s.ctl_acc = cur;  // held value for the extra frames
          s.ctl_count = 1;
        }
      }
    }

    // Run whole codec blocks.
    const size_t b = s.block;
    while (s.src_in.Available() >= b && s.ctl_avail() >= b) {
      beads::FloatFrame in_frames[kMaxBlock], out_frames[kMaxBlock];
      float tl[kMaxBlock], tr[kMaxBlock];
      s.src_in.Pull(tl, tr, b);

      bool freeze[kMaxBlock];
      stmlib::GateFlags seed[kMaxBlock];
      float cv_mean[kNumCv] = { 0, 0, 0, 0, 0 };
      for (size_t i = 0; i < b; ++i) {
        const CtlFrame& cf = s.ctl[(s.ctl_r + i) % kCtlRing];
        for (int c = 0; c < kNumCv; ++c) cv_mean[c] += cf.cv[c];
        freeze[i] = p.freeze || cf.freeze > 0.5f;
        s.previous_seed = stmlib::ExtractGateFlags(
            s.previous_seed, cf.seed > 0.5f);
        seed[i] = s.previous_seed;
      }
      s.ctl_r += b;
      for (int c = 0; c < kNumCv; ++c) cv_mean[c] /= float(b);

      // Input stage: gain and per-media clipping (stands in for the
      // hardware gain_control: soft clipping for dirty tape).
      for (size_t i = 0; i < b; ++i) {
        float l = tl[i] * p.gain, r = tr[i] * p.gain;
        if (s.media == beads::Processor::MEDIA_DIRTY_TAPE) {
          const float bias = 0.05f;
          l = (1.0f - bias) * stmlib::SoftClip(l + bias) - bias;
          r = (1.0f - bias) * stmlib::SoftClip(r + bias) - bias;
        }
        in_frames[i].l = std::min(1.0f, std::max(-1.0f, l));
        in_frames[i].r = std::min(1.0f, std::max(-1.0f, r));
      }

      // ---- LFO bank: advance one codec block and rebuild the modulation table.
      beads::GrainModulation& gm = s.gm;
      if (!s.lfo_init) {
        for (int i = 0; i < kNumLfos; ++i) s.last_reset[i] = p.lfo[i].reset;
        s.lfo_init = true;
      }
      const double block_seconds = double(b) / s.codec_sr;
      const float bpm = p.tempo > 1.0f ? p.tempo : 120.0f;
      for (int i = 0; i < kNumLfos; ++i) {
        const LfoParams& lp = p.lfo[i];
        if (lp.reset != s.last_reset[i]) {
          s.last_reset[i] = lp.reset;
          gm.cycles[i] = 0.0;
        }
        const float hz = lp.sync ? (bpm / 60.0f) / DivisionBeats(lp.div)
                                 : Clamp(lp.rate, 0.0f, 100.0f);
        gm.cycles[i] += double(hz) * block_seconds;
        gm.shape[i] = uint8_t(lp.shape < 0 ? 0 : (lp.shape > 6 ? 6 : lp.shape));
        gm.unipolar[i] = lp.uni != 0;
        gm.split[i] = Clamp(lp.split_deg, 0.0f, 360.0f) / 360.0f;
      }
      for (int dd = 0; dd < NUM_DESTS; ++dd)
        for (int i = 0; i < kNumLfos; ++i)
          gm.depth[dd][i] = Clamp(p.mod[dd][i] * 0.01f, -1.0f, 1.0f);

      // Block level: every destination gets the LFOs at the centre phase.
      float off[NUM_DESTS];
      for (int dd = 0; dd < NUM_DESTS; ++dd) off[dd] = gm.Offset(dd, 0.0f);
      // Grain level is only needed if some LFO feeds time / shape / pitch with a split.
      // Phase alone creates the stereo split: an LFO that feeds one of those and has a split
      // spreads the grains across the stereo field by itself (full width at 180 degrees), so
      // the left and right edges really hear different LFO phases. The Spread knob adds to it.
      bool grain_split = false;
      float phase_width = 0.0f;
      const int kPerGrain[3] = { DEST_TIME, DEST_SHAPE, DEST_PITCH };
      for (int i = 0; i < kNumLfos; ++i) {
        bool assigned = false;
        for (int k = 0; k < 3; ++k) assigned |= gm.depth[kPerGrain[k]][i] != 0.0f;
        if (assigned && gm.split[i] > 0.0f) {
          grain_split = true;
          phase_width = std::max(phase_width, Clamp(gm.split[i] * 2.0f, 0.0f, 1.0f));
        }
      }

      beads::Parameters prm;
      prm.time = { Clamp(p.time + off[DEST_TIME], 0.0f, 1.0f), p.time_amt, cv_mean[0],
                   in[IN_TIME_CV] != nullptr };
      prm.size = { Clamp(p.size + off[DEST_SIZE], 0.0f, 1.0f), p.size_amt, cv_mean[1],
                   in[IN_SIZE_CV] != nullptr };
      prm.shape = { Clamp(p.shape + off[DEST_SHAPE], 0.0f, 1.0f), p.shape_amt, cv_mean[2],
                    in[IN_SHAPE_CV] != nullptr };
      prm.pitch = { Clamp(p.pitch + off[DEST_PITCH], -24.0f, 24.0f), p.pitch_amt, cv_mean[3],
                    in[IN_PITCH_CV] != nullptr };
      prm.monophonic_mode = false;
      prm.modulation = grain_split ? &gm : nullptr;
      prm.spread = Clamp(p.spread + phase_width, 0.0f, 1.0f);
      beads::ModulatedParameter d;
      d.base = Clamp(p.density + off[DEST_DENSITY], 0.0f, 1.0f);
      d.cv = in[IN_DENSITY_CV] ? cv_mean[4] : 0.0f;

      beads::Processor::MixParameters m;
      m.feedback = Clamp((p.feedback + off[DEST_FEEDBACK]) * 1.005f, 0.0f, 1.0f);
      m.dry_wet = Clamp((p.dry_wet + off[DEST_DRYWET]) * 1.005f, 0.0f, 1.0f);
      m.reverb_amount = Clamp((p.reverb + off[DEST_REVERB]) * 1.005f, 0.0f, 1.0f);
      m.output_gate = p.gate_out != 0;

      beads::SeedButtonState sb = p.seed_button == 2
          ? beads::SEED_BUTTON_STATE_LOCKED
          : (p.seed_button == 1 ? beads::SEED_BUTTON_STATE_ON
                                : beads::SEED_BUTTON_STATE_OFF);

      const size_t grains_before = s.grains_seen;
      s.processor.Process(sb, in[IN_SEED] ? seed : nullptr, freeze, d, prm, m,
                          in_frames, out_frames, b);
      for (size_t i = 0; i < b; ++i) {
        s.trig_hist[(s.trig_written + i) & (kTrigHist - 1)] =
            (i == 0 && s.grains_seen != grains_before) ? 1.0f : 0.0f;
      }
      s.trig_written += b;

      for (size_t i = 0; i < b; ++i) {
        const float l = out_frames[i].l, r = out_frames[i].r;
        s.src_out.PushOne(std::isfinite(l) ? l : 0.0f,
                          std::isfinite(r) ? r : 0.0f);
      }
    }

    // Publish the LFO state for displays: what the left and right edges of the
    // stereo field see, and the centre phase.
    if (s.lfo_init) {
      for (int i = 0; i < kNumLfos; ++i) {
        const double half = 0.5 * double(s.gm.split[i]);
        s.ro_l[i].store(s.gm.Lfo(i, -half), std::memory_order_relaxed);
        s.ro_r[i].store(s.gm.Lfo(i, +half), std::memory_order_relaxed);
        s.ro_phase[i].store(float(s.gm.cycles[i] - std::floor(s.gm.cycles[i])),
                            std::memory_order_relaxed);
      }
    }

    // Pull host-rate output; zero-fill on underrun.
    const size_t avail = std::min(s.src_out.Available(), m);
    if (avail) s.src_out.Pull(out_l + base, out_r + base, avail);
    for (size_t i = avail; i < m; ++i) out_l[base + i] = out_r[base + i] = 0.0f;

    if (out_trig) {
      // Walk the flag history at the same rate src_out walks its input; emit
      // 1.0 once for each flagged codec sample passed.
      for (size_t i = 0; i < avail; ++i) {
        const size_t idx = size_t(s.trig_pos);
        float v = 0.0f;
        while (s.trig_last < idx) {
          ++s.trig_last;
          v = std::max(v, s.trig_hist[s.trig_last & (kTrigHist - 1)]);
        }
        out_trig[base + i] = v;
        s.trig_pos += s.ctl_step;
      }
      for (size_t i = avail; i < m; ++i) out_trig[base + i] = 0.0f;
    }
  }
}

}  // namespace beads_max
