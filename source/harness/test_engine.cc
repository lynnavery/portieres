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
  printf("%d failures\n", fails);
  return fails != 0;
}
