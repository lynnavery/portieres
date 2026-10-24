// Copyright 2017 Emilie Gillet.
//
// Author: Emilie Gillet (emilie.o.gillet@gmail.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
// 
// See http://creativecommons.org/licenses/MIT/ for more information.
//
// -----------------------------------------------------------------------------
//
// Multitap delay.

#ifndef BEADS_DSP_MULTITAP_DELAY_H_
#define BEADS_DSP_MULTITAP_DELAY_H_

#include <cmath>
#include <cstring>

#include "stmlib/stmlib.h"
#include "stmlib/dsp/filter.h"

#include "beads/dsp/tap.h"
#include "beads/dsp/delay_controller.h"

#define ENABLE_BANDWIDTH_CONTROL

namespace beads {

// Port addition: Spread for delay mode. The taps read the buffer as it is, so there is nothing to pan:
// the stereo image is the input's, and at a steady Time setting only a single tap sounds. Spread widens
// that image instead by decorrelation. The mid signal (L+R)/2 goes through two different chains of three
// allpass filters (flat in level, scattered in phase, a few milliseconds long), one for each channel, and
// Spread blends each channel from the plain mid signal towards its own allpassed copy. At 1 the left and
// right are two different phase-scrambled copies: each keeps its full level at every frequency, so
// neither side can lean, and a mono echo comes out wide. The side signal (L-R)/2 is kept as it is, so a
// stereo source stays what it was and gets extra width on top. The level is compensated.
class TapWidener {
 public:
  TapWidener() { }
  ~TapWidener() { }

  void Init(float sample_rate) {
    // samples at 48 kHz: about 3 to 8 ms; the two channels use different lengths
    static const int kBase[2][kStages] = { { 149, 223, 331 }, { 181, 269, 397 } };
    const float k = sample_rate / 48000.0f;
    for (int c = 0; c < 2; ++c) {
      for (int i = 0; i < kStages; ++i) {
        int n = int(float(kBase[c][i]) * k + 0.5f);
        length_[c][i] = n < 8 ? 8 : (n > kMaxLength ? kMaxLength : n);
      }
    }
    Reset();
  }

  void Reset() {
    memset(buffer_, 0, sizeof(buffer_));
    for (int c = 0; c < 2; ++c) for (int i = 0; i < kStages; ++i) position_[c][i] = 0;
  }

  inline FloatFrame Process(const FloatFrame& in, float amount) {
    const float mid = 0.5f * (in.l + in.r);
    const float side = 0.5f * (in.l - in.r);
    float a = mid, b = mid;
    for (int i = 0; i < kStages; ++i) {
      a = Allpass(0, i, a);
      b = Allpass(1, i, b);
    }
    const float dry = 1.0f - amount;
    // blending a signal with an uncorrelated copy of itself loses power: dry^2 + amount^2
    const float comp = 1.0f / std::sqrt(dry * dry + amount * amount);
    FloatFrame out;
    out.l = (dry * mid + amount * a) * comp + side;
    out.r = (dry * mid + amount * b) * comp - side;
    return out;
  }

 private:
  enum { kStages = 3, kMaxLength = 1024 };

  // Schroeder allpass: v = x + g * v[n-D];  y = -g * v + v[n-D]
  inline float Allpass(int c, int i, float x) {
    const float g = 0.6f;
    float* buf = buffer_[c][i];
    int p = position_[c][i];
    const float delayed = buf[p];
    const float v = x + g * delayed;
    buf[p] = v;
    if (++p >= length_[c][i]) p = 0;
    position_[c][i] = p;
    return -g * v + delayed;
  }

  float buffer_[2][kStages][kMaxLength];
  int length_[2][kStages];
  int position_[2][kStages];
};

class MultitapDelay {
 public:
  MultitapDelay() { }
  ~MultitapDelay() { }
  
  inline void Init(float sample_rate) {
    Reset();
    for (int i = 0; i < 2; ++i) {
      filter_[i].Init();
    }
    widener_.Init(sample_rate);
  }
  
  inline void Reset() {
    for (int i = 0; i < DelayController::NUM_TAPS; ++i) {
      tap_[i].Init();
      no_latency_tap_[i].Init();
    }
    widener_.Reset();
  }
  
  template<typename DelayLineType>
  inline void Render(
      const DelayLineType* delay_line,
      DelayController::Output taps,
      float speed,
      float bandwidth,
      FloatFrame* out,
      float spread = 0.0f) {
    
    // Cross-fade between the original and pitch-shifted delays.
    float gain = 100.0f * (fabsf(speed - 1.0f) - 0.01f);
    CONSTRAIN(gain, 0.0f, 1.0f);

    FloatFrame mix;
    mix.l = mix.r = 0.0f;
    for (int i = 0; i < DelayController::NUM_TAPS; ++i) {
      tap_[i].Render(
          delay_line,
          taps.tap[i].delay,
          taps.tap[i].gain * gain,
          speed,
          &mix);
      no_latency_tap_[i].Render(
          delay_line,
          taps.tap[i].delay,
          taps.tap[i].gain * (1.0f - gain),
          speed,
          &mix);
    }

#ifdef ENABLE_BANDWIDTH_CONTROL
    const float amount = fabsf(2.0f * bandwidth - 1.0f);
    
    // LP: -7 to -2 octaves
    // HP: -8 to -3 octaves
    const float octave = bandwidth < 0.5f
        ? -7.0f + bandwidth * 10.0f
        : -8.0f + (bandwidth - 0.5f) * 10.0f;
    const float f = 0.49f * stmlib::SemitonesToRatio(12.0f * octave);
    const float q = 1.0f + 16.0f * amount * f;
    const float wet_amount_sqrt = amount * (2.0f - amount);
    const float wet_amount = wet_amount_sqrt * (2.0f - wet_amount_sqrt);
    
    filter_[0].set_f_q<stmlib::FREQUENCY_FAST>(f, q);
    filter_[1].set(filter_[0]);
    
    FloatFrame wet;
    if (bandwidth < 0.5f) {
      wet.l = filter_[0].Process<stmlib::FILTER_MODE_LOW_PASS>(mix.l);
      wet.r = filter_[1].Process<stmlib::FILTER_MODE_LOW_PASS>(mix.r);
    } else {
      wet.l = filter_[0].Process<stmlib::FILTER_MODE_HIGH_PASS>(mix.l);
      wet.r = filter_[1].Process<stmlib::FILTER_MODE_HIGH_PASS>(mix.r);
    }
    FloatFrame tap_out = mix + (wet - mix) * wet_amount;
#else
    FloatFrame tap_out = mix;
#endif  // ENABLE_BANDWIDTH_CONTROL
    if (spread > 0.0f) tap_out = widener_.Process(tap_out, spread);
    *out += tap_out;
  }

 private:
  Tap<2048> tap_[DelayController::NUM_TAPS];
  Tap<1> no_latency_tap_[DelayController::NUM_TAPS];
  stmlib::Svf filter_[2];
  TapWidener widener_;

  DISALLOW_COPY_AND_ASSIGN(MultitapDelay);
};

}  // namespace beads

#endif  // BEADS_DSP_MULTITAP_DELAY_H_
