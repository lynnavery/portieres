// Offline test of beads_max::Engine at various host rates / vector sizes.
#include <cmath>
#include <cstdio>
#include <vector>
#include "ext/engine.h"
using namespace beads_max;

int main() {
  int fails = 0;
  const double rates[] = { 44100, 48000, 96000 };
  const int vecs[] = { 16, 64, 37 };
  for (double sr : rates) for (int media = 0; media < 4; ++media) for (int vs : vecs) {
    Engine e; e.Setup(sr, vs, media, false);
    Params p; p.dry_wet = 0.0f; p.reverb = 0.0f; p.feedback = 0.0f;  // dry path only
    const int total = int(sr * 3);
    std::vector<float> L(vs), R(vs), oL(vs), oR(vs);
    double ph = 0, e_out = 0, peak = 0; long cnt = 0; int zc = 0; float prev = 0; bool nan = false;
    for (int n = 0; n < total; n += vs) {
      for (int i = 0; i < vs; ++i) { L[i] = 0.4f * sinf(ph); R[i] = L[i]; ph += 2 * M_PI * 1000.0 / sr; }
      const float* in[NUM_INPUTS] = { L.data(), R.data(), 0,0,0,0,0,0,0 };
      e.Process(p, in, oL.data(), oR.data(), vs);
      if (n > sr) for (int i = 0; i < vs; ++i) {
        if (!std::isfinite(oL[i])) nan = true;
        e_out += oL[i] * oL[i]; ++cnt; peak = std::max(peak, (double)fabsf(oL[i]));
        if (prev < 0 && oL[i] >= 0) ++zc; prev = oL[i];
      }
    }
    double rms = sqrt(e_out / cnt), freq = zc / (double(cnt) / sr);
    // expected dry gain 0.75 -> rms 0.4*0.75/sqrt2 = 0.212
    bool ok = !nan && fabs(rms - 0.212) < 0.03 && fabs(freq - 1000.0) < 15.0;
    if (media == 0 && sr == 44100) ok = !nan && rms > 0.1;  // mu-law dry path, looser
    printf("sr=%6.0f media=%d vec=%2d codec=%5.0f rms=%.3f freq=%.1f lat=%d %s\n", sr, media, vs, e.codec_rate(), rms, freq, e.latency_samples(), ok ? "OK" : "FAIL");
    fails += !ok;
  }
  // Grain events and trigger signal.
  for (double sr : rates) for (int media = 0; media < 4; ++media) {
    struct Case { const char* name; float density, size; double secs, skip; bool expect_grains; } cases[] = {
      { "granular", 0.9f, 0.2f, 4.0, 0.5, true },
      { "dead zone", 0.5f, 0.2f, 3.0, 0.5, false },
      { "delay mode", 0.9f, 1.0f, 6.0, 3.0, false },  // grains stop after the transition
    };
    for (const Case& c : cases) {
      const int vs = 64;
      Engine e; e.Setup(sr, vs, media, false);
      Params p; p.density = c.density; p.size = c.size; p.dry_wet = 1.0f;
      p.seed_button = 2;  // locked: the pulse train runs without a seed gate
      std::vector<float> oL(vs), oR(vs), oT(vs);
      const float* in[NUM_INPUTS] = { 0,0,0,0,0,0,0,0,0 };
      long events = 0, impulses = 0; bool bad = false, prev_hi = false;
      GrainEvent ev[64];
      const int total = int(sr * c.secs);
      for (int n = 0; n < total; n += vs) {
        e.Process(p, in, oL.data(), oR.data(), vs, oT.data());
        const bool count = n > sr * c.skip;
        for (int i = 0; i < vs; ++i) {
          const bool hi = oT[i] > 0.5f;
          if (oT[i] != 0.0f && oT[i] != 1.0f) bad = true;
          if (count && hi && !prev_hi) ++impulses;
          prev_hi = hi;
        }
        size_t k;
        while ((k = e.PopGrains(ev, 64)) > 0) {
          for (size_t j = 0; j < k; ++j) {
            if (!(ev[j].duration > 0 && ev[j].pitch_ratio > 0 && ev[j].pan >= 0 && ev[j].pan <= 1)) bad = true;
          }
          if (count) events += long(k);
        }
      }
      bool ok = !bad;
      if (c.expect_grains) ok = ok && events > 5 && impulses >= events * 0.8 && impulses <= events;
      else ok = ok && events == 0 && impulses == 0;
      printf("grains sr=%6.0f media=%d %-10s events=%ld impulses=%ld %s\n", sr, media, c.name, events, impulses, ok ? "OK" : "FAIL");
      fails += !ok;
    }
  }
  printf("%d failures\n", fails);
  return fails != 0;
}
