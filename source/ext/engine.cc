#include "ext/engine.h"

#include <algorithm>
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
}  // namespace

struct Engine::Impl {
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

  size_t ctl_avail() const { return ctl_w - ctl_r; }
};

Engine::Engine() : impl_(new Impl) {
  impl_->buffer1 = static_cast<uint8_t*>(calloc(512 * 1024, 1));
  impl_->buffer2 = static_cast<uint8_t*>(calloc(256 * 1024, 1));
  impl_->reverb_buffer = static_cast<uint16_t*>(calloc(32768, sizeof(uint16_t)));
  uint8_t* buffers[3] = { impl_->buffer1, impl_->buffer1 + 256 * 1024,
                          impl_->buffer2 };
  impl_->processor.Init(buffers, impl_->reverb_buffer);
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
  s.primed = true;
  s.configured = true;
  latency_ = int(std::ceil((double(prime) / s.ctl_step) +
                           s.src_in.latency_in_samples() +
                           s.src_out.latency_in_samples() / s.ctl_step));
}

void Engine::Process(const Params& p, const float* const* in, float* out_l,
                     float* out_r, size_t n) {
  Impl& s = *impl_;
  if (!s.configured) {
    std::fill(out_l, out_l + n, 0.0f);
    std::fill(out_r, out_r + n, 0.0f);
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

      beads::Parameters prm;
      prm.time = { p.time, p.time_amt, cv_mean[0], in[IN_TIME_CV] != nullptr };
      prm.size = { p.size, p.size_amt, cv_mean[1], in[IN_SIZE_CV] != nullptr };
      prm.shape = { p.shape, p.shape_amt, cv_mean[2], in[IN_SHAPE_CV] != nullptr };
      prm.pitch = { p.pitch, p.pitch_amt, cv_mean[3], in[IN_PITCH_CV] != nullptr };
      prm.monophonic_mode = false;
      beads::ModulatedParameter d;
      d.base = p.density;
      d.cv = in[IN_DENSITY_CV] ? cv_mean[4] : 0.0f;

      beads::Processor::MixParameters m;
      m.feedback = std::min(1.0f, std::max(0.0f, p.feedback * 1.005f));
      m.dry_wet = std::min(1.0f, std::max(0.0f, p.dry_wet * 1.005f));
      m.reverb_amount = std::min(1.0f, std::max(0.0f, p.reverb * 1.005f));
      m.output_gate = p.gate_out != 0;

      beads::SeedButtonState sb = p.seed_button == 2
          ? beads::SEED_BUTTON_STATE_LOCKED
          : (p.seed_button == 1 ? beads::SEED_BUTTON_STATE_ON
                                : beads::SEED_BUTTON_STATE_OFF);

      s.processor.Process(sb, in[IN_SEED] ? seed : nullptr, freeze, d, prm, m,
                          in_frames, out_frames, b);

      for (size_t i = 0; i < b; ++i) {
        const float l = out_frames[i].l, r = out_frames[i].r;
        s.src_out.PushOne(std::isfinite(l) ? l : 0.0f,
                          std::isfinite(r) ? r : 0.0f);
      }
    }

    // Pull host-rate output; zero-fill on underrun.
    const size_t avail = std::min(s.src_out.Available(), m);
    if (avail) s.src_out.Pull(out_l + base, out_r + base, avail);
    for (size_t i = avail; i < m; ++i) out_l[base + i] = out_r[base + i] = 0.0f;
  }
}

}  // namespace beads_max
