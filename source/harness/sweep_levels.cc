// Output-level sweep of beads_max::Engine: how much louder than the input does the wet path get,
// across the parameter space, and how often does it reach the output limiter's ceiling?
//
//   sweep_levels <sweep> [media] [wetcap 0|1] [overlap 0|1]     prints CSV rows to stdout
//   (wetcap defaults to 1 = the engine default, overlap to 0; pass 0 0 to reproduce the original engine)
//   sweeps: grid (density x size, 0.05 steps), coarse (density x size, 0.1 steps, hot inputs),
//           knobs (one parameter at a time at two anchor settings), limiter (steady-state check)
//
// Columns: sweep,media,input,level_db,density,size,time,shape,pitch,size_amt,time_amt,shape_amt,pitch_amt,
//          feedback,reverb,dry_wet,spread,gain,gain_db,peak,frac_over_0.9,frac_over_1.0
// gain_db = output power (L and R averaged) relative to the input power over the last 2 s of a 4 s run.
#include <algorithm>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include <vector>
#include "ext/engine.h"
#include "stmlib/utils/random.h"
using namespace beads_max;

enum Src { TONE, NOISE, STEREO_NOISE, NUM_SRC };
static const char* kSrcName[] = { "tone", "noise", "stereo_noise" };

struct Result { double gain_db, peak, over09, over10; };

// Grains read from `time` x the delay buffer, and the buffer is empty until that much audio has been
// recorded: at the default Time of 0.5 the wet path is silent for about half the buffer length
// (digital 4 s, vintage digital 8 s, clean tape 8 s, dirty tape 16 s). Runs must outlast the buffer
// or they measure silence. The last 2 s of each run are measured.
static double RunSeconds(int media) {
  static const double kBuffer[4] = { 16.0, 8.0, 8.0, 4.0 };   // by media: dirty, clean, vintage, digital
  return kBuffer[media] + 3.0;
}

// secs <= 0: pick the run length from the media.
static Result Measure(Params p, int media, int input, double level_db, double secs = 0.0, double sr = 48000.0) {
  if (secs <= 0.0) secs = RunSeconds(media);
  const int vs = 64;
  stmlib::Random::Seed(777);
  Engine e; e.Setup(sr, vs, media, false);
  p.seed_button = 2;
  const double amp = std::pow(10.0, level_db / 20.0) * 1.41421356;     // peak of a sine with this RMS
  const double namp = std::pow(10.0, level_db / 20.0) * 1.7320508;     // peak of uniform noise with this RMS
  std::vector<float> L(vs), R(vs), oL(vs), oR(vs);
  uint32_t s = 12345; double ph = 0, in2 = 0, out2 = 0, pk = 0; long n = 0, o09 = 0, o10 = 0;
  auto noise = [&]() { s = s * 1664525u + 1013904223u; return float(s >> 8) / 8388608.0f - 1.0f; };
  for (int t = 0; t < int(sr * secs); t += vs) {
    for (int i = 0; i < vs; ++i) {
      if (input == TONE) { L[i] = R[i] = float(amp * std::sin(ph)); ph += 2 * M_PI * 220.0 / sr; }
      else if (input == NOISE) { L[i] = R[i] = float(namp * noise()); }
      else { L[i] = float(namp * noise()); R[i] = float(namp * noise()); }
    }
    const float* in[NUM_INPUTS] = { L.data(), R.data(), 0, 0, 0, 0, 0, 0, 0 };
    e.Process(p, in, oL.data(), oR.data(), vs);
    if (t > sr * (secs - 2.0)) {
      for (int i = 0; i < vs; ++i) {
        in2 += 0.5 * (L[i] * L[i] + R[i] * R[i]);
        out2 += 0.5 * (oL[i] * oL[i] + oR[i] * oR[i]);
        const double m = std::max(fabsf(oL[i]), fabsf(oR[i]));
        pk = std::max(pk, m); o09 += m > 0.9; o10 += m > 1.0; ++n;
      }
    }
  }
  return { 10 * std::log10((out2 + 1e-20) / (in2 + 1e-20)), pk, double(o09) / n, double(o10) / n };
}

static void Row(const char* sweep, int media, int input, double level, const Params& p, const Result& r) {
  printf("%s,%d,%s,%.0f,%.3f,%.3f,%.3f,%.3f,%.1f,%.2f,%.2f,%.2f,%.2f,%.3f,%.3f,%.3f,%.3f,%.3f,%.2f,%.3f,%.4f,%.4f\n",
         sweep, media, kSrcName[input], level, p.density, p.size, p.time, p.shape, p.pitch,
         p.size_amt, p.time_amt, p.shape_amt, p.pitch_amt, p.feedback, p.reverb, p.dry_wet, p.spread, p.gain,
         r.gain_db, r.peak, r.over09, r.over10);
  fflush(stdout);
}

static int g_wetcap = 1, g_overlap = 0;
static Params Base() { Params p; p.dry_wet = 1.0f; p.wetcap = g_wetcap; p.overlap = g_overlap; return p; }

int main(int argc, char** argv) {
  const std::string sweep = argc > 1 ? argv[1] : "";
  const int media = argc > 2 ? atoi(argv[2]) : 3;
  if (argc > 3) g_wetcap = atoi(argv[3]);
  if (argc > 4) g_overlap = atoi(argv[4]);
  if (sweep == "grid") {                       // density x size, 0.05 steps, -20 dBFS input
    for (int input = 0; input < NUM_SRC; ++input)
      for (int d = 0; d <= 20; ++d) for (int z = 0; z <= 20; ++z) {
        Params p = Base(); p.density = d * 0.05f; p.size = z * 0.05f;
        Row("grid", media, input, -20, p, Measure(p, media, input, -20));
      }
  } else if (sweep == "coarse") {              // density x size, 0.1 steps, hot inputs
    for (int input = 0; input < NUM_SRC; ++input) for (double lv : { -12.0, -6.0 })
      for (int d = 0; d <= 10; ++d) for (int z = 0; z <= 10; ++z) {
        Params p = Base(); p.density = d * 0.1f; p.size = z * 0.1f;
        Row("coarse", media, input, lv, p, Measure(p, media, input, lv));
      }
  } else if (sweep == "knobs") {               // one knob at a time, at the defaults and at the worst case found by the grid
    struct Anchor { const char* name; float density, size; } anchors[] = { { "default", 0.7f, 0.5f }, { "dense_long", 1.0f, 0.8f } };
    for (const Anchor& a : anchors) {
      auto base = [&]() { Params p = Base(); p.density = a.density; p.size = a.size; return p; };
      auto run = [&](const char* knob, Params p) { Row(knob, media, TONE, -20, p, Measure(p, media, TONE, -20)); };
      for (int i = 0; i <= 20; ++i) { Params p = base(); p.time = i * 0.05f; run("time", p); }
      for (int i = 0; i <= 20; ++i) { Params p = base(); p.shape = i * 0.05f; run("shape", p); }
      for (int i = -12; i <= 12; ++i) { Params p = base(); p.pitch = i * 2.0f; run("pitch", p); }
      for (int i = -10; i <= 10; ++i) {
        Params p = base(); p.size_amt = i * 0.1f; run("size_amt", p);
        p = base(); p.time_amt = i * 0.1f; run("time_amt", p);
        p = base(); p.shape_amt = i * 0.1f; run("shape_amt", p);
        p = base(); p.pitch_amt = i * 0.1f; run("pitch_amt", p);
      }
      for (int i = 0; i <= 20; ++i) {
        Params p = base(); p.feedback = i * 0.05f; run("feedback", p);
        p = base(); p.reverb = i * 0.05f; run("reverb", p);
        p = base(); p.dry_wet = i * 0.05f; run("dry_wet", p);
        p = base(); p.spread = i * 0.05f; run("spread", p);
      }
      for (double g : { 0.25, 0.5, 1.0, 2.0, 4.0, 8.0 }) { Params p = base(); p.gain = (float)g; run("gain", p); }
      for (int deg = 0; deg <= 360; deg += 30) {       // LFO phase: a barely-modulating time LFO just switches the split on
        Params p = base(); p.lfo[0].rate = 0.02f; p.mod[DEST_TIME][0] = 1.0f; p.lfo[0].split_deg = (float)deg; run("phase", p);
      }
      // the anchor label rides in the `sweep` column's neighbour: re-emit a marker row
      printf("# anchor %s density=%.2f size=%.2f\n", a.name, a.density, a.size);
    }
  } else if (sweep == "limiter") {             // long steady state: does the output ever sit above the 0.9 ceiling?
    for (double lv : { -20.0, -12.0, -6.0, -3.0 }) for (int input = 0; input < NUM_SRC; ++input) {
      Params p = Base(); p.density = 1.0f; p.size = 0.8f;
      Row("limiter", media, input, lv, p, Measure(p, media, input, lv));
      p.feedback = 1.0f;
      Row("limiter_fb1", media, input, lv, p, Measure(p, media, input, lv));
    }
  } else {
    fprintf(stderr, "usage: sweep_levels <grid|coarse|knobs|limiter> [media]\n");
    return 2;
  }
  return 0;
}
