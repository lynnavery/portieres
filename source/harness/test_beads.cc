// Offline smoke test: runs beads::Processor for all media x mono/stereo and
// checks for NaN / silence. Build with ../build_test.sh
#include <cmath>
#include <cstdio>
#include <cstring>
#include <vector>
#include "beads/dsp/processor.h"

using namespace beads;

int main() {
  static uint8_t b1[512 * 1024], b2[256 * 1024];
  static uint16_t reverb[32768];
  uint8_t* bufs[3] = { b1, b1 + 256 * 1024, b2 };
  static Processor proc;
  memset(b1, 0, sizeof(b1)); memset(b2, 0, sizeof(b2)); memset(reverb, 0, sizeof(reverb));
  proc.Init(bufs, reverb);
  int fails = 0;
  for (int media = 0; media < 4; ++media) for (int mono = 0; mono < 2; ++mono)
  for (int mode = 0; mode < 2; ++mode) {  // 0 = granular, 1 = delay (size > 0.99)
    proc.Configure(Processor::Media(media), mono);
    const int block = int(proc.sample_rate() / 4000.0f);
    const int total = int(proc.sample_rate() * 6);
    double energy = 0; bool bad = false; float peak = 0;
    float phase = 0;
    for (int n = 0; n < total; n += block) {
      FloatFrame in[64], out[64]; bool freeze[64]; stmlib::GateFlags seed[64];
      for (int i = 0; i < block; ++i) {
        float s = 0.4f * sinf(phase); phase += 6.2831853f * 220.0f / proc.sample_rate();
        in[i].l = s; in[i].r = mono ? s : -s; freeze[i] = false; seed[i] = stmlib::GATE_FLAG_LOW;
      }
      Parameters p;
      p.time = { 0.5f, 0.0f, 0.0f, false };
      p.size = { mode ? 1.0f : 0.5f, 0.0f, 0.0f, false };
      p.shape = { 0.5f, 0.0f, 0.0f, false };
      p.pitch = { 0.5f, 0.0f, 0.0f, false };
      p.monophonic_mode = false;
      ModulatedParameter d = { 0.6f, 0.0f };
      Processor::MixParameters m = { 0.3f, 0.6f, 0.3f, false };
      proc.Process(SEED_BUTTON_STATE_OFF, NULL, freeze, d, p, m, in, out, block);
      for (int i = 0; i < block; ++i) {
        if (!std::isfinite(out[i].l) || !std::isfinite(out[i].r)) bad = true;
        energy += out[i].l * out[i].l + out[i].r * out[i].r;
        peak = std::max(peak, std::max(fabsf(out[i].l), fabsf(out[i].r)));
      }
    }
    bool ok = !bad && energy > 1e-3;
    printf("media=%d mono=%d %-8s sr=%5.0f block=%2d rms=%.4f peak=%.3f %s\n", media, mono,
           mode ? "delay" : "granular", proc.sample_rate(), block,
           sqrt(energy / (2.0 * total)), peak, ok ? "OK" : "FAIL");
    fails += !ok;
  }
  printf("%d failures\n", fails);
  return fails != 0;
}
