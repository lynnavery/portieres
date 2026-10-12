// Arbitrary-ratio windowed-sinc stereo resampler (push input, pull output).
// Used to bridge the host sample rate and the fixed codec rates (24/32/48 kHz)
// that the Beads DSP was designed around. Exact pass-through when rates match.
#ifndef BEADS_MAX_RESAMPLER_H_
#define BEADS_MAX_RESAMPLER_H_

#include <algorithm>
#include <cmath>
#include <cstddef>
#include <vector>

namespace beads_max {

class Resampler {
 public:
  void Init(double in_sr, double out_sr) {
    bypass_ = in_sr == out_sr;
    step_ = in_sr / out_sr;
    const double ratio = std::min(1.0, out_sr / in_sr);
    // Cutoff in cycles per input sample, leaving a transition band below the
    // output Nyquist.
    const double fc = 0.5 * ratio * 0.92;
    const double kZeroCrossings = 12.0;
    half_width_ = kZeroCrossings / (2.0 * fc);
    fc_ = fc;
    if (table_.empty()) table_.resize(kTable + 2);
    for (int i = 0; i <= kTable + 1; ++i) {
      const double u = double(i) / kTable;  // 0..1 across the half-width
      const double d = u * half_width_;
      const double x = 2.0 * fc * d;
      const double sinc = x < 1e-9 ? 1.0 : std::sin(M_PI * x) / (M_PI * x);
      const double w = 0.42 + 0.5 * std::cos(M_PI * u) + 0.08 * std::cos(2.0 * M_PI * u);
      table_[i] = float(2.0 * fc * sinc * w);
    }
    hist_l_.assign(kHist, 0.0f);
    hist_r_.assign(kHist, 0.0f);
    written_ = 0;
    pos_ = 0.0;
  }

  // Input samples already pushed minus the position of the next output.
  void Push(const float* l, const float* r, size_t n) {
    for (size_t i = 0; i < n; ++i) {
      hist_l_[written_ & (kHist - 1)] = l[i];
      hist_r_[written_ & (kHist - 1)] = r[i];
      ++written_;
    }
  }

  void PushOne(float l, float r) { Push(&l, &r, 1); }

  // Number of output frames that can be pulled right now.
  size_t Available() const {
    if (bypass_) return size_t(written_ - size_t(pos_));
    const double last = double(written_) - half_width_ - 1.0;
    if (last < pos_) return 0;
    return size_t((last - pos_) / step_) + 1;
  }

  void Pull(float* l, float* r, size_t n) {
    for (size_t k = 0; k < n; ++k) {
      if (bypass_) {
        const size_t idx = size_t(pos_) & (kHist - 1);
        l[k] = hist_l_[idx];
        r[k] = hist_r_[idx];
        pos_ += 1.0;
        continue;
      }
      const long first = long(std::ceil(pos_ - half_width_));
      const long last = long(std::floor(pos_ + half_width_));
      float acc_l = 0.0f, acc_r = 0.0f, wsum = 0.0f;
      const double scale = kTable / half_width_;
      for (long i = first; i <= last; ++i) {
        const double a = std::fabs(double(i) - pos_) * scale;
        const int ia = int(a);
        const float f = float(a - ia);
        const float w = table_[ia] + (table_[ia + 1] - table_[ia]) * f;
        const size_t idx = size_t(i) & (kHist - 1);
        acc_l += w * hist_l_[idx];
        acc_r += w * hist_r_[idx];
        wsum += w;
      }
      const float inv = wsum > 1e-6f ? 1.0f / wsum : 1.0f;
      l[k] = acc_l * inv;
      r[k] = acc_r * inv;
      pos_ += step_;
    }
  }

  double latency_in_samples() const { return bypass_ ? 0.0 : half_width_; }

 private:
  static constexpr int kTable = 4096;
  static constexpr size_t kHist = 16384;
  bool bypass_ = true;
  double step_ = 1.0, half_width_ = 1.0, fc_ = 0.5, pos_ = 0.0;
  size_t written_ = 0;
  std::vector<float> table_, hist_l_, hist_r_;
};

}  // namespace beads_max

#endif  // BEADS_MAX_RESAMPLER_H_
