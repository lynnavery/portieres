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
// Granular player.

#ifndef BEADS_DSP_DELAY_GRANULAR_PLAYER_H_
#define BEADS_DSP_DELAY_GRANULAR_PLAYER_H_

#include "stmlib/stmlib.h"

#include "beads/dsp/delay_grain.h"
#include "beads/dsp/granular_player.h"

namespace beads {

// Reported to an observer (if set) every time a grain starts. portieres~ port
// addition, used for visualisation; it does not change the audio.
struct GrainEvent {
  float time;        // read position, 0..1 across the buffer (Time knob)
  float pitch_ratio; // playback speed ratio, always positive
  float duration;    // seconds
  float shape;       // 0..1
  float amplitude;
  float pan;         // 0..1, 0.5 centre
  bool reverse;
};

class GrainObserver {
 public:
  virtual ~GrainObserver() { }
  virtual void OnGrain(const GrainEvent& e) = 0;
};

class DelayGranularPlayer : public GranularPlayer<DelayGrain, 32> {
 public:
  DelayGranularPlayer() : observer_(NULL) { }
  ~DelayGranularPlayer() { }

  void set_observer(GrainObserver* observer) { observer_ = observer; }
  
  template<typename DelayLineType>
  inline void Render(
      const DelayLineType* delay_line,
      const TriggerGenerator::Output& trigger,
      const Parameters& p,
      FloatFrame* out) {
    if (trigger.trigger) {
      const float duration = p.size.value();
      const bool reverse = duration < 0.3333333f;

      float amplitude, pan, stereo;
      ComputeGrainAmplitudeAndPan(trigger, p, &amplitude, &pan, &stereo);
      
      const int safety = DelayGrain::head_crossing_safety_zone + 1;
      const int max_delay = delay_line->duration() - 2 * safety;

      // Locals keep the original argument evaluation order (and so the
      // random sequence).
      // Port addition: per-grain LFO split. The block-level LFO value is already
      // in the bases; here a grain only adds how its stereo position differs from
      // the centre (zero when the LFO split is 0). The stereo position is the grain's
      // own random draw (the same one that offsets its pan), so the grain at the left
      // extreme always sees the full -split/2 and the right extreme +split/2, whatever
      // the pan width. Size is drawn before the pan exists, so it follows the centre
      // value only. Copies of the parameters keep the number of random draws (and so
      // the sequence) unchanged.
      float d_time = 0.0f, d_pitch = 0.0f, d_shape = 0.0f;
      if (p.modulation) {
        const float u = stereo < -1.0f ? -1.0f : (stereo > 1.0f ? 1.0f : stereo);
        d_time = p.modulation->GrainDelta(MOD_TIME, u);
        d_pitch = p.modulation->GrainDelta(MOD_PITCH, u);
        d_shape = p.modulation->GrainDelta(MOD_SHAPE, u);
      }
      RandomizedParameter time_p = p.time;
      RandomizedParameter pitch_p = p.pitch;
      RandomizedParameter shape_p = p.shape;
      time_p.base += d_time;
      pitch_p.base += d_pitch;
      shape_p.base += d_shape;

      const float time = time_p.value();
      const float pitch_ratio = pitch_p.pitch_value();
      const float grain_duration = ComputeGrainDuration(duration);
      const float shape = shape_p.value();

      new_grain()->Start(
          delay_line,
          time * float(max_delay) + float(safety),
          (reverse ? -1.0f : 1.0f) * pitch_ratio,
          grain_duration,
          shape,
          amplitude, pan,
          trigger.fractional_sample);
      if (observer_) {
        GrainEvent e;
        e.time = time;
        e.pitch_ratio = pitch_ratio;
        e.duration = grain_duration / sample_rate_;
        e.shape = shape;
        e.amplitude = amplitude;
        e.pan = pan;
        e.reverse = reverse;
        observer_->OnGrain(e);
      }
      SortGrainList(p.monophonic_mode);
    }

    for (int i = 0; i < NUM_GRAINS; ++i) {
      grain_[i].Render<HEAD_CROSSING_POLICY_STOP, true>(delay_line, out);
    }

    Tick();  // Required to estimate the timing between grains.
  }

 private:
  GrainObserver* observer_;
  DISALLOW_COPY_AND_ASSIGN(DelayGranularPlayer);
};

}  // namespace beads

#endif  // BEADS_DSP_DELAY_GRANULAR_PLAYER_H_
