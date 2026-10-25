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
// The whole FX chain.

#include "beads/dsp/processor.h"

#include <algorithm>

#include "beads/dsp/mu_law.h"

namespace beads {

const float kDelayModeTransitionTime = 1.5f;  // seconds
const float kDelayModeFadeTime = 0.75f;  // seconds

using namespace std;
using namespace stmlib;

void Processor::Init(
    uint8_t* buffers[],
    uint16_t* reverb_buffer) {
  processor_digital_.Init(48000.0f, buffers);
  processor_vintage_digital_.Init(32000.0f, buffers);
  processor_clean_tape_.Init(24000.0f, buffers);
  processor_dirty_tape_.Init(24000.0f, buffers);
  
  dry_ = 0.0f;
  wet_ = 0.0f;
  
  reverb_.Init(reverb_buffer, 48000.0f);
#ifdef ENABLE_HARDWARE_24K
  wow_and_flutter_.Init(24000.0f);
  wow_and_flutter_.set_lp(0.95f);
#else
  wow_and_flutter_.Init(48000.0f);
  wow_and_flutter_.set_lp(0.6f);
#endif  // ENABLE_HARDWARE_24K

  Configure(MEDIA_DIGITAL, false);
  
  // Used for the timing of the delay to granular transition.
  delay_mode_transition_ = -kDelayModeTransitionTime;
}

void Processor::Configure(Media media, bool mono) {
  media_ = media;
  mono_ = mono;
  
  int max_delay = 0;

  switch (media_) {
    case MEDIA_DIGITAL:
      processor_digital_.Reset();
      max_delay = processor_digital_.max_delay_times_ratio();
      break;
    case MEDIA_VINTAGE_DIGITAL:
      processor_vintage_digital_.Reset();
      max_delay = processor_vintage_digital_.max_delay_times_ratio();
      break;
    case MEDIA_CLEAN_TAPE:
      processor_clean_tape_.Reset();
      max_delay = processor_clean_tape_.max_delay_times_ratio();
      break;
    case MEDIA_DIRTY_TAPE:
      processor_dirty_tape_.Reset();
      max_delay = processor_dirty_tape_.max_delay_times_ratio();
      break;
  }
  
  cap_in_pow_ = 0.0f;
  cap_in_smooth_ = 0.0f;
  cap_wet_pow_ = 0.0f;
  cap_gain_ = 1.0f;
  wet_gain_ = 1.0f;

  float sr = sample_rate();
  pre_reverb_limiter_.Init(1.0f / (sr * 4.0f), 0.9f);
  output_limiter_.Init(1.0f / (sr * 6.0f), 0.9f);
  trigger_generator_.Init(sr);
  delay_controller_.Init(sr, max_delay * (mono ? 2 : 1));
  reverb_.Reset(sr);
}

void Processor::Process(
    SeedButtonState seed_button_state,
    const stmlib::GateFlags* seed_input,
    const bool* freeze,
    const ModulatedParameter& density,
    const Parameters& parameters,
    const MixParameters& mix_parameters,
    const FloatFrame* in,
    FloatFrame* out,
    size_t size) {
  const float delay_mode = delay_mode_transition_ > 0.0f;
  const float threshold = delay_mode ? 0.98f : 0.99f;
  const float direction = parameters.size.base > threshold ? 1.0f : -1.0f;
  delay_mode_transition_ += direction * float(size) / sample_rate();
  
  CONSTRAIN(delay_mode_transition_,
            -kDelayModeTransitionTime,
            +kDelayModeTransitionTime);
  
  float expo_fm_amount = 20.0f * (fabsf(density.base - 0.5f) - 0.225f);
  CONSTRAIN(expo_fm_amount, 0.0f, 1.0f);

  TriggerGenerator::Output triggers_buffer[size];
  DelayController::Output taps_buffer[size];
  bool gate_out[size];

  TriggerGenerator::Output* triggers = &triggers_buffer[0];
  DelayController::Output* taps = &taps_buffer[0];
  
  // Extract grain triggers.
  if (delay_mode) {
    triggers = NULL;
    delay_controller_.Render(
        seed_button_state,
        seed_input,
        freeze,
        density.base,
        (1.0f - expo_fm_amount) * density.cv,
        expo_fm_amount * density.cv,
        parameters.time,
        parameters.shape,
        taps,
        size);
    for (size_t i = 0; i < size; ++i) {
      gate_out[i] = taps[i].gate;
    }
  } else {
    taps = NULL;
    trigger_generator_.Render(
        seed_button_state,
        seed_input,
        density.base,
        (1.0f - expo_fm_amount) * density.cv,
        expo_fm_amount * density.cv,
        triggers,
        size);
    for (size_t i = 0; i < size; ++i) {
      gate_out[i] = triggers[i].gate;
    }
  }
  
  FloatFrame dry_signal[size];
  
  // Granular processing.
  const float feedback = mix_parameters.feedback;
  switch (media_) {
    case MEDIA_DIGITAL:
      processor_digital_.Process(
          triggers, taps, freeze, parameters, feedback, mono_, in, out, size);
      copy(&in[0], &in[size], &dry_signal[0]);
      break;
    
    case MEDIA_VINTAGE_DIGITAL:
      processor_vintage_digital_.Process(
          triggers, taps, freeze, parameters, feedback, mono_, in, out, size);
      for (size_t i = 0; i < size; ++i) {
        dry_signal[i].l = static_cast<int32_t>(in[i].l * 4096.0f) / 4096.0f;
        dry_signal[i].r = static_cast<int32_t>(in[i].r * 4096.0f) / 4096.0f;
      }
      break;
    
    case MEDIA_CLEAN_TAPE:
      processor_clean_tape_.Process(
          triggers, taps, freeze, parameters, feedback, mono_, in, out,
          size);
      copy(&in[0], &in[size], &dry_signal[0]);
      break;
    
    case MEDIA_DIRTY_TAPE:
      processor_dirty_tape_.Process(
          triggers, taps, freeze, parameters, feedback, mono_, in, out,
          size);
      for (size_t i = 0; i < size; ++i) {
        dry_signal[i].l = MuLaw2Lin(
            Lin2MuLaw(
                stmlib::Clip16(static_cast<int32_t>(in[i].l * 32768.0f))));
        dry_signal[i].r = MuLaw2Lin(
            Lin2MuLaw(
                stmlib::Clip16(static_cast<int32_t>(in[i].r * 32768.0f))));
      }
      break;
  }
  
  // Port addition: in post-mix mode the dry signal is the clean input (no bit-crushing, no soft clip).
  if (mix_parameters.post_mix && mix_parameters.clean_dry) {
    for (size_t i = 0; i < size; ++i) dry_signal[i] = mix_parameters.clean_dry[i];
  }

  // Fade-out / Fade-in the dry signal when switching between granular and
  // Delay mode.
  const float wet_fade = SmoothStep(
      std::min(1.0f, fabsf(delay_mode_transition_) / kDelayModeFadeTime));
  
  // Dry/wet balance.
  const float post_gain_dry = 0.75f;
  const float post_gain_wet = 1.5f;
  const float dry_wet = mix_parameters.dry_wet;
  const float dry = (1.0f - dry_wet) * (1.0f + dry_wet) * post_gain_dry;
  const float wet = dry_wet * (2.0f - dry_wet) * post_gain_wet * wet_fade;

  stmlib::ParameterInterpolator dry_modulation(&dry_, dry, size);
  stmlib::ParameterInterpolator wet_modulation(&wet_, wet, size);

  // Port addition: wet-path level cap. Overlapping grains of the same material can add up to
  // 10-15 dB more than went in (the original relied on a fixed 0.9 peak limiter and on the
  // hardware input AGC feeding it a hot signal). With the cap on, the wet signal is eased down
  // whenever it exceeds the input level by more than the cap, and left alone otherwise.
  // The input estimate has a long memory and is held while frozen, so tails, feedback and
  // frozen textures are not clamped just because the live input went quiet. With the cap off
  // the arithmetic below is exactly the original.
  const float cap_ratio = mix_parameters.wet_cap_ratio;
  const bool cap_on = cap_ratio > 0.0f;
  const float cap_ratio2 = cap_ratio * cap_ratio;
  const float sr_cap = sample_rate();
  const float in_attack = 1.0f / (sr_cap * 0.05f);
  const float in_release = 1.0f / (sr_cap * 10.0f);
  const float wet_slew = 1.0f / (sr_cap * 0.15f);
  const float gain_attack = 1.0f / (sr_cap * 0.03f);
  const float gain_release = 1.0f / (sr_cap * 0.4f);
  const float wet_gain_slew = 1.0f / (sr_cap * 0.02f);

  const bool post_mix = mix_parameters.post_mix;
  FloatFrame dry_only[size];
  for (size_t i = 0; i < size; ++i) {
    const float dry_gain = dry_modulation.Next();
    FloatFrame wet_signal = wet_modulation.Next() * out[i];
    if (cap_on) {
      // Mean power of the input over ~150 ms first (instantaneous power of a sine swings
      // between 0 and twice its mean, which would bias the follower below up by 3 dB), then a
      // fast-attack / slow-release follower on that.
      const float in_inst = 0.5f * (in[i].l * in[i].l + in[i].r * in[i].r);
      cap_in_smooth_ += wet_slew * (in_inst - cap_in_smooth_);
      if (!freeze[i]) {
        cap_in_pow_ += (cap_in_smooth_ > cap_in_pow_ ? in_attack : in_release) *
                       (cap_in_smooth_ - cap_in_pow_);
      }
      const float wet_p = 0.5f * (wet_signal.l * wet_signal.l + wet_signal.r * wet_signal.r);
      cap_wet_pow_ += wet_slew * (wet_p - cap_wet_pow_);
      const float limit = cap_in_pow_ * cap_ratio2;
      const float target = (cap_wet_pow_ > limit && cap_wet_pow_ > 1.0e-12f)
          ? sqrtf(limit / cap_wet_pow_) : 1.0f;
      cap_gain_ += (target < cap_gain_ ? gain_attack : gain_release) * (target - cap_gain_);
      wet_signal.l *= cap_gain_;
      wet_signal.r *= cap_gain_;
    } else {
      cap_gain_ = 1.0f;
    }
    // output gain of the wet signal, smoothed over about 20 ms so turning it does not click
    wet_gain_ += wet_gain_slew * (mix_parameters.wet_gain - wet_gain_);
    wet_signal.l *= wet_gain_;
    wet_signal.r *= wet_gain_;
    if (post_mix) {
      dry_only[i] = dry_gain * dry_signal[i];
      out[i] = wet_signal;           // wobble and reverb below see the wet signal alone
    } else {
      out[i] = dry_gain * dry_signal[i] + wet_signal;
    }
  }
  
  // Wow and flutter simulation.
  if (media_ == MEDIA_DIRTY_TAPE) {
    wow_and_flutter_.Process(out, size);
  }
  
  pre_reverb_limiter_.Process(out, size);
  
  // Reverb.
  const bool caveman = media_ != MEDIA_DIGITAL;
  const float reverb = mix_parameters.reverb_amount;
  const float reverb_mix = reverb * reverb * 0.9f;
  const float reverb_time = reverb * reverb * reverb;
  reverb_.set_mix(reverb_mix);
  reverb_.set_time(caveman
      ? (0.45f + 0.5f * reverb_time)
      : (0.3f + 0.6f * reverb_time));
  reverb_.set_lp(
      caveman ? 0.4f : (media_ == MEDIA_VINTAGE_DIGITAL ? 0.75f : 0.6f));
  reverb_.Process(out, size);

  if (post_mix) {
    for (size_t i = 0; i < size; ++i) out[i] = out[i] + dry_only[i];
  }
  
  // Final clipping/limiting
  output_limiter_.Process(out, size);
  
  if (mix_parameters.output_gate) {
    for (size_t i = 0; i < size; ++i) {
      out[i].l = (out[i].l + out[i].r) * 0.5f;
      out[i].r = gate_out[i] ? -0.8f : 0.0f;
    }
  }
}

}  // namespace beads