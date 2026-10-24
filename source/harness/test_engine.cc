// Offline test of beads_max::Engine at various host rates / vector sizes.
#include <algorithm>
#include <cmath>
#include <cstdio>
#include <vector>
#include "beads/dsp/grain_modulation.h"
#include "ext/engine.h"
#include "stmlib/utils/random.h"
using namespace beads_max;

// ---- LFO modulation / spread tests --------------------------------------------------------
namespace {

struct Run { std::vector<GrainEvent> grains; float lfo_phase[kNumLfos], lfo_l[kNumLfos], lfo_r[kNumLfos], lfo_hz[kNumLfos]; };

// Runs a fresh engine with the random generator seeded, collecting grains after `skip` seconds.
Run Go(Params p, double secs, double skip = 0.5, double sr = 48000.0, int vs = 64) {
  stmlib::Random::Seed(12345);
  Engine e; e.Setup(sr, vs, 3, false);
  p.seed_button = 2; p.dry_wet = 1.0f;
  std::vector<float> oL(vs), oR(vs);
  const float* in[NUM_INPUTS] = { 0,0,0,0,0,0,0,0,0 };
  Run r; GrainEvent ev[64];
  for (int n = 0; n < int(sr * secs); n += vs) {
    e.Process(p, in, oL.data(), oR.data(), vs);
    size_t k;
    while ((k = e.PopGrains(ev, 64)) > 0)
      if (n > sr * skip) r.grains.insert(r.grains.end(), ev, ev + k);
  }
  for (int i = 0; i < kNumLfos; ++i) e.GetLfo(i, &r.lfo_l[i], &r.lfo_r[i], &r.lfo_phase[i], &r.lfo_hz[i]);
  return r;
}

double Semis(const GrainEvent& g) { return 12.0 * std::log2((double)g.pitch_ratio); }
double Mean(const std::vector<double>& v) { double s = 0; for (double x : v) s += x; return v.empty() ? 0 : s / v.size(); }
double Std(const std::vector<double>& v) { double m = Mean(v), s = 0; for (double x : v) s += (x - m) * (x - m); return v.empty() ? 0 : std::sqrt(s / v.size()); }
double Corr(const std::vector<double>& a, const std::vector<double>& b) {
  double ma = Mean(a), mb = Mean(b), sab = 0, saa = 0, sbb = 0;
  for (size_t i = 0; i < a.size(); ++i) { sab += (a[i] - ma) * (b[i] - mb); saa += (a[i] - ma) * (a[i] - ma); sbb += (b[i] - mb) * (b[i] - mb); }
  return (saa > 0 && sbb > 0) ? sab / std::sqrt(saa * sbb) : 0.0;
}

// Mean output power (L and R together) relative to a 220 Hz mono input, wet only.
double LevelDb(Params p) {
  const double sr = 48000; const int vs = 64;
  stmlib::Random::Seed(777);
  Engine e; e.Setup(sr, vs, 3, false);
  p.dry_wet = 1.0f; p.seed_button = 2;
  std::vector<float> L(vs), oL(vs), oR(vs);
  double ph = 0, in2 = 0, out2 = 0;
  for (int t = 0; t < int(sr * 8); t += vs) {
    for (int i = 0; i < vs; ++i) { L[i] = 0.1414f * sinf(ph); ph += 2 * M_PI * 220.0 / sr; }
    const float* in[NUM_INPUTS] = { L.data(), L.data(), 0, 0, 0, 0, 0, 0, 0 };
    e.Process(p, in, oL.data(), oR.data(), vs);
    if (t > sr * 3) for (int i = 0; i < vs; ++i) { in2 += L[i] * L[i]; out2 += 0.5 * (oL[i] * oL[i] + oR[i] * oR[i]); }
  }
  return 10 * std::log10((out2 + 1e-20) / (in2 + 1e-20));
}

int Check(bool ok, const char* what, double a = 0, double b = 0) {
  printf("mod   %-62s %s  (%.3f, %.3f)\n", what, ok ? "OK" : "FAIL", a, b);
  return ok ? 0 : 1;
}

// Level of the wet path while the input is switched off (optionally frozen) after `lead` seconds of tone.
// Returns dBFS RMS (L and R averaged) over the last 1.5 s.
double TailDbfs(Params p, double lead, double tail, bool freeze_in_tail) {
  const double sr = 48000; const int vs = 64;
  stmlib::Random::Seed(777);
  Engine e; e.Setup(sr, vs, 3, false);
  p.dry_wet = 1.0f; p.seed_button = 2;
  std::vector<float> L(vs), oL(vs), oR(vs);
  double ph = 0, out2 = 0; long n = 0;
  for (int t = 0; t < int(sr * (lead + tail)); t += vs) {
    const bool in_tail = t >= int(sr * lead);
    p.freeze = (in_tail && freeze_in_tail) ? 1 : 0;
    for (int i = 0; i < vs; ++i) { L[i] = in_tail ? 0.0f : 0.1414f * sinf(ph); ph += 2 * M_PI * 220.0 / sr; }
    const float* in[NUM_INPUTS] = { L.data(), L.data(), 0, 0, 0, 0, 0, 0, 0 };
    e.Process(p, in, oL.data(), oR.data(), vs);
    if (t > sr * (lead + tail - 1.5)) for (int i = 0; i < vs; ++i) { out2 += 0.5 * (oL[i] * oL[i] + oR[i] * oR[i]); ++n; }
  }
  return 10 * std::log10(out2 / n + 1e-20);
}

// Level cap and overlap scaling.
int TestLevelControl() {
  int f = 0;
  Params def;                                            // density .7, size .5: the everyday case
  Params dense = def; dense.density = 1.0f; dense.size = 0.8f;      // +11 dB above the input without the cap
  Params regular = def; regular.density = 0.0f; regular.size = 0.9f;  // +15 dB above the input without the cap
  auto with = [](Params p, int cap, float db, int ov, float amt) { p.wetcap = cap; p.wetcap_db = db; p.overlap = ov; p.overlap_amt = amt; return p; };

  // Cap off is the original behaviour, cap on only acts when the wet path runs hot.
  const double hot_off = LevelDb(with(dense, 0, 3, 0, 1)), reg_off = LevelDb(with(regular, 0, 3, 0, 1));
  f += Check(hot_off > 8.0 && reg_off > 11.0, "without the cap, dense/long and regular/long grains run 8+ and 11+ dB hot", hot_off, reg_off);
  for (float db : { 0.0f, 3.0f, 6.0f }) {
    const double h = LevelDb(with(dense, 1, db, 0, 1)), r = LevelDb(with(regular, 1, db, 0, 1));
    char what[96];
    snprintf(what, sizeof what, "cap %+.0f dB holds dense/long and regular/long grains to about +%.0f dB", db, db);
    f += Check(h < db + 1.5 && r < db + 1.5 && h > db - 3.5 && r > db - 3.5, what, h, r);
  }
  // It stays out of the way everywhere else.
  double worst = 0;
  for (float d : { 0.2f, 0.3f, 0.6f, 0.7f, 0.8f }) for (float z : { 0.2f, 0.4f, 0.5f, 0.6f }) {
    Params p = def; p.density = d; p.size = z;
    worst = std::max(worst, std::fabs(LevelDb(with(p, 1, 3, 0, 1)) - LevelDb(with(p, 0, 3, 0, 1))));
  }
  f += Check(worst < 0.5, "away from the hot zone the cap changes the level by under 0.5 dB (worst of 20 settings)", worst);

  // Tails and Freeze must not be clamped just because the live input went quiet.
  const double tail_off = TailDbfs(with(dense, 0, 3, 0, 1), 5.0, 3.0, false);
  const double tail_on = TailDbfs(with(dense, 1, 3, 0, 1), 5.0, 3.0, false);
  f += Check(tail_on > -26.0 && tail_on < tail_off + 0.5, "input stops: the tail is capped but not silenced", tail_off, tail_on);
  const double frz_off = TailDbfs(with(dense, 0, 3, 0, 1), 5.0, 4.0, true);
  const double frz_on = TailDbfs(with(dense, 1, 3, 0, 1), 5.0, 4.0, true);
  f += Check(frz_on > -26.0 && frz_on < frz_off + 0.5, "Freeze with the input silent: the frozen texture is capped but not silenced", frz_off, frz_on);

  // Overlap scaling: 0 / off = original, more amount = quieter when many grains overlap.
  const double o_off = LevelDb(with(dense, 0, 3, 0, 1)), o_zero = LevelDb(with(dense, 0, 3, 1, 0.0f));
  const double o_half = LevelDb(with(dense, 0, 3, 1, 0.5f)), o_full = LevelDb(with(dense, 0, 3, 1, 1.0f));
  f += Check(std::fabs(o_zero - o_off) < 0.05, "overlap on with amount 0 is the original", o_off, o_zero);
  f += Check(o_full < o_half - 1.5 && o_half < o_off - 1.5, "overlap scaling: more amount = quieter dense grains (off > 0.5 > 1.0)", o_half, o_full);
  f += Check(o_off - o_full > 6.0, "overlap scaling at 1.0 takes 6+ dB off the dense/long case", o_off, o_full);
  const double d_off = LevelDb(with(def, 0, 3, 0, 1)), d_full = LevelDb(with(def, 0, 3, 1, 1.0f));
  f += Check(d_off - d_full < o_off - o_full, "it bites less on sparse settings than on dense ones", d_off - d_full, o_off - o_full);
  // Both on together.
  const double both = LevelDb(with(dense, 1, 3, 1, 1.0f));
  f += Check(both <= std::min(LevelDb(with(dense, 1, 3, 0, 1)), o_full) + 0.5, "cap and overlap scaling together are never louder than either alone", both);
  return f;
}

// Delay mode (Size > 0.99): Spread pans every other tap from the original (mono input stays mono) towards
// hard left / hard right.
struct DelayMeasure { double l_db, r_db, total_db, diff_db, corr; bool finite; };
DelayMeasure MeasureDelay(float spread, bool stereo_noise, float density, float time, bool freeze, int split_lfo = 0) {
  const double sr = 48000; const int vs = 64;
  stmlib::Random::Seed(7);
  Engine e; e.Setup(sr, vs, 3, false);
  Params p; p.size = 1.0f; p.density = density; p.time = time; p.dry_wet = 1.0f; p.wetcap = 0; p.spread = spread;
  if (split_lfo) { p.lfo[0].rate = 2.0f; p.lfo[0].split_deg = 180.0f; p.mod[DEST_TIME][0] = 100.0f; p.mod[DEST_PITCH][0] = 100.0f; }
  std::vector<float> iL(vs), iR(vs), oL(vs), oR(vs);
  const float* in[NUM_INPUTS] = { iL.data(), iR.data(), 0,0,0,0,0,0,0 };
  double sl = 0, sr2 = 0, sd = 0, slr = 0, n = 0; bool fin = true; unsigned rng = 12345;
  auto noise = [&]() { rng = rng * 1664525u + 1013904223u; return (rng >> 8) * (2.0f / 16777216.0f) - 1.0f; };
  for (int k = 0; k < int(sr * 9); k += vs) {
    for (int i = 0; i < vs; ++i) {
      if (stereo_noise) { iL[i] = 0.3f * noise(); iR[i] = 0.3f * noise(); }
      else iL[i] = iR[i] = 0.3f * std::sin(2 * M_PI * 220.0 * (k + i) / sr);
    }
    p.freeze = (freeze && k > sr * 3) ? 1 : 0;
    e.Process(p, in, oL.data(), oR.data(), vs);
    if (k > sr * (freeze ? 4 : 3)) for (int i = 0; i < vs; ++i) {
      fin &= std::isfinite(oL[i]) && std::isfinite(oR[i]);
      sl += oL[i] * oL[i]; sr2 += oR[i] * oR[i]; sd += (oL[i] - oR[i]) * (oL[i] - oR[i]); slr += oL[i] * oR[i]; n += 1;
    }
  }
  DelayMeasure m;
  m.l_db = 10 * std::log10(sl / n + 1e-20); m.r_db = 10 * std::log10(sr2 / n + 1e-20);
  m.total_db = 10 * std::log10((sl + sr2) / n + 1e-20);
  m.diff_db = 10 * std::log10(sd / n + 1e-20);
  m.corr = slr / std::sqrt(sl * sr2 + 1e-30);
  m.finite = fin;
  return m;
}

int TestDelaySpread() {
  int f = 0;
  // Spread 0 is the original: a mono input comes out identical on both channels.
  DelayMeasure z = MeasureDelay(0.0f, false, 0.9f, 0.55f, false);
  f += Check(z.diff_db < -150.0 && z.finite, "delay mode, Spread 0: a mono input stays exactly mono", z.diff_db);
  // Frozen delay (the loops alternate between the master and the slave head): Spread widens a mono source.
  DelayMeasure a = MeasureDelay(0.25f, false, 0.9f, 0.55f, true), b = MeasureDelay(0.5f, false, 0.9f, 0.55f, true),
               c = MeasureDelay(1.0f, false, 0.9f, 0.55f, true), z2 = MeasureDelay(0.0f, false, 0.9f, 0.55f, true);
  f += Check(a.diff_db > z2.diff_db + 20 && b.diff_db > a.diff_db && c.diff_db > b.diff_db,
             "frozen delay: the stereo difference grows with Spread (0.25 < 0.5 < 1)", a.diff_db, c.diff_db);
  f += Check(c.corr < 0.3 && z2.corr > 0.99, "frozen delay: Spread 1 decorrelates the channels (mono corr 1.0 -> below 0.3)", z2.corr, c.corr);
  f += Check(std::fabs(c.total_db - z2.total_db) < 3.0 && std::fabs(b.total_db - z2.total_db) < 3.0 && std::fabs(a.total_db - z2.total_db) < 3.0,
             "frozen delay, mono source: the total level stays within 3 dB of Spread 0", z2.total_db, c.total_db);
  // A stereo source: the level also holds, and the channels are not made identical or silent.
  DelayMeasure n0 = MeasureDelay(0.0f, true, 0.9f, 0.55f, true), n1 = MeasureDelay(1.0f, true, 0.9f, 0.55f, true);
  f += Check(std::fabs(n1.total_db - n0.total_db) < 3.0 && n1.finite, "frozen delay, stereo noise: the total level stays within 3 dB", n0.total_db, n1.total_db);
  // Live delay: every other multiple of the delay goes to the other side, so the two channels differ.
  DelayMeasure l0 = MeasureDelay(0.0f, false, 0.9f, 0.2f, false), l1 = MeasureDelay(1.0f, false, 0.9f, 0.2f, false);
  f += Check(l0.diff_db < -150.0 && l1.diff_db > -40.0 && std::fabs(l1.total_db - l0.total_db) < 3.0 && l1.finite,
             "live delay: Spread 1 separates the channels and keeps the total level within 3 dB", l0.total_db, l1.total_db);
  // Only the Spread knob does this: an LFO with a Phase split does nothing to the taps.
  DelayMeasure s = MeasureDelay(0.0f, false, 0.9f, 0.55f, false, 1);
  f += Check(s.diff_db < -150.0, "delay mode: an LFO Phase split alone does not widen the taps", s.diff_db);
  return f;
}

int TestModulation() {
  int f = 0;
  Params base; base.density = 0.9f; base.size = 0.2f;

  // The LFO shapes themselves (pure maths).
  {
    beads::GrainModulation g;
    g.shape[0] = beads::LFO_SINE; g.cycles[0] = 0.0;
    f += Check(std::fabs(g.Lfo(0, 0.0) - 1.0f) < 1e-5 && std::fabs(g.Lfo(0, 0.5)) < 1e-5, "sine starts at the top (0..1) and reaches the bottom at half a cycle", g.Lfo(0, 0.0), g.Lfo(0, 0.5));
    g.depth[beads::MOD_PITCH][0] = 1.0f;
    f += Check(std::fabs(g.Offset(beads::MOD_PITCH, 0.0f) - 24.0f) < 1e-3, "+100% on pitch: the LFO peak is +24 st (half of the 48 st range) above the knob", g.Offset(beads::MOD_PITCH, 0.0f));
    f += Check(g.GrainDelta(beads::MOD_PITCH, 1.0f) == 0.0f, "split 0: a grain differs from the centre by exactly 0");
    g.split[0] = 0.5f;   // 180 degrees
    g.cycles[0] = 0.25;  // the centre is half way down, the right edge (+90deg) at the bottom, the left (-90deg) at the top
    f += Check(std::fabs(g.GrainDelta(beads::MOD_PITCH, 1.0f) + 24.0f) < 1e-3 && std::fabs(g.GrainDelta(beads::MOD_PITCH, -1.0f) - 24.0f) < 1e-3, "split 180deg: hard right sees +90deg, hard left -90deg", g.GrainDelta(beads::MOD_PITCH, 1.0f), g.GrainDelta(beads::MOD_PITCH, -1.0f));
    f += Check(std::fabs(g.GrainDelta(beads::MOD_PITCH, -1.0f) + g.GrainDelta(beads::MOD_PITCH, 1.0f)) < 1e-3, "left and right deltas are mirror images");
    g.shape[0] = beads::LFO_RANDOM; g.split[0] = 0.0f;
    f += Check(g.Lfo(0, 0.0) == g.Lfo(0, 0.4), "random is constant within a cycle");
    f += Check(g.Lfo(0, 0.0) != g.Lfo(0, 1.0), "random changes between cycles");
  }

  // 0a. The nine shapes, the curve, steps and the output scaling follow the Live LFO device.
  {
    beads::GrainModulation g;
    auto at = [&](int shape, double x) { g.shape[0] = shape; g.cycles[0] = x; return g.Lfo(0, 0.0); };
    f += Check(std::fabs(at(beads::LFO_UP, 0.25) - 0.25f) < 1e-6 && std::fabs(at(beads::LFO_DOWN, 0.25) - 0.75f) < 1e-6, "up and down are ramps", at(beads::LFO_UP, 0.25), at(beads::LFO_DOWN, 0.25));
    f += Check(std::fabs(at(beads::LFO_TRIANGLE, 0.25) - 0.5f) < 1e-6 && std::fabs(at(beads::LFO_TRIANGLE, 0.5) - 1.0f) < 1e-6 && std::fabs(at(beads::LFO_TRIANGLE, 0.75) - 0.5f) < 1e-6, "triangle rises to the top at half a cycle", at(beads::LFO_TRIANGLE, 0.25), at(beads::LFO_TRIANGLE, 0.75));
    f += Check(at(beads::LFO_SQUARE, 0.25) == 0.0f && at(beads::LFO_SQUARE, 0.75) == 1.0f, "square is low first, then high", at(beads::LFO_SQUARE, 0.25), at(beads::LFO_SQUARE, 0.75));
    bool bin_ok = true, stray_ok = true, glide_ok = true, rnd_ok = true;
    for (int c = 0; c < 200; ++c) {
      const double x = c + 0.37;
      const float b = at(beads::LFO_BIN, x), r = at(beads::LFO_RANDOM, x), st = at(beads::LFO_STRAY, x), gl = at(beads::LFO_GLIDER, x);
      bin_ok &= (b == 0.0f || b == 1.0f);
      rnd_ok &= r >= 0.0f && r <= 1.0f;
      stray_ok &= st >= 0.0f && st <= 1.0f && std::isfinite(st);
      glide_ok &= gl >= 0.0f && gl <= 1.0f;
    }
    f += Check(bin_ok && rnd_ok && stray_ok && glide_ok, "bin is 0/1; random, stray and glider stay inside 0..1");
    // glider is continuous across cycle boundaries (it glides between the random values)
    f += Check(std::fabs(at(beads::LFO_GLIDER, 5.0 - 1e-5) - at(beads::LFO_GLIDER, 5.0 + 1e-5)) < 1e-3, "glider has no jump at a cycle boundary", at(beads::LFO_GLIDER, 5.0 - 1e-5), at(beads::LFO_GLIDER, 5.0 + 1e-5));
    // wave-shape curve: bends the wave, exponent 1/(1-0.0095*amount)
    g.shape[0] = beads::LFO_UP; g.cycles[0] = 0.5; g.wave[0] = 1.0f;
    f += Check(std::fabs(g.Lfo(0, 0.0) - std::pow(0.5f, 1.0f / (1.0f - 0.95f))) < 1e-5, "wave +100%: x^20 on the way up", g.Lfo(0, 0.0));
    g.wave[0] = -1.0f;
    f += Check(std::fabs(g.Lfo(0, 0.0) - (1.0f - std::pow(0.5f, 20.0f))) < 1e-5, "wave -100%: mirrored", g.Lfo(0, 0.0));
    // On a square the curve moves the edge (pulse width): the edge is where the bent phase reaches 0.5
    g.shape[0] = beads::LFO_SQUARE; g.wave[0] = 0.5f;
    g.cycles[0] = 0.6;  const float sq06 = g.Lfo(0, 0.0);
    g.cycles[0] = 0.8;  const float sq08 = g.Lfo(0, 0.0);
    g.wave[0] = 0.0f;
    g.cycles[0] = 0.6;  const float sq06_flat = g.Lfo(0, 0.0);
    f += Check(sq06 == 0.0f && sq08 == 1.0f && sq06_flat == 1.0f, "wave +50% on a square moves the edge from 0.5 to about 0.7 (pulse width)", sq06, sq08);
    g.shape[0] = beads::LFO_SINE; g.wave[0] = 1.0f; g.cycles[0] = 0.5;
    f += Check(std::fabs(g.Lfo(0, 0.0) - (std::cos(6.2831853f * std::pow(0.5f, 20.0f)) + 1.0f) * 0.5f) < 1e-4, "wave on a sine skews its phase", g.Lfo(0, 0.0));
    g.wave[0] = 0.0f;
    g.shape[0] = beads::LFO_RANDOM; const float rnd_flat = g.Lfo(0, 0.0);
    f += Check(rnd_flat == g.Lfo(0, 0.0), "the curve does not apply to random");
    // steps: 4 levels, not for square
    g.shape[0] = beads::LFO_UP; g.wave[0] = 0.0f; g.steps[0] = 4;
    bool levels = true;
    for (int k = 0; k <= 100; ++k) { g.cycles[0] = k / 101.0; const float v = g.Lfo(0, 0.0), q = std::floor(v * 4.0f + 0.5f) / 4.0f; levels &= std::fabs(v - q) < 1e-5; }
    f += Check(levels, "steps 4: the ramp only takes the values 0, .25, .5, .75, 1");
    g.shape[0] = beads::LFO_SQUARE; g.cycles[0] = 0.75;
    f += Check(g.Lfo(0, 0.0) == 1.0f, "steps do not touch the square");
    // output scaling: offset + depth * (value - 0.5), clipped
    g.steps[0] = 0; g.shape[0] = beads::LFO_UP; g.cycles[0] = 1.0 - 1e-9;      // the top of the ramp, value 1
    g.depth01[0] = 0.5f; g.offset01[0] = 0.5f;
    f += Check(std::fabs(g.Lfo(0, 0.0) - 0.75f) < 1e-4, "depth 50% around the middle: the top of the ramp is 0.75", g.Lfo(0, 0.0));
    g.offset01[0] = 0.9f;
    f += Check(std::fabs(g.Lfo(0, 0.0) - 1.0f) < 1e-6, "offset +80% pushes the top past 1: clipped", g.Lfo(0, 0.0));
    g.depth01[0] = 0.0f; g.offset01[0] = 0.3f;
    f += Check(std::fabs(g.Lfo(0, 0.0) - 0.3f) < 1e-6, "depth 0: the output is the offset", g.Lfo(0, 0.0));
    // hold returns the held value to every read, whatever the phase
    g.depth01[0] = 1.0f; g.offset01[0] = 0.5f; g.holding[0] = 1; g.held[0] = 0.8f;
    f += Check(std::fabs(g.Lfo(0, 0.0) - 0.8f) < 1e-6 && std::fabs(g.Lfo(0, 0.3) - 0.8f) < 1e-6, "hold: every read returns the held value", g.Lfo(0, 0.0), g.Lfo(0, 0.3));
  }

  // 0b0. Time-domain parts and the signal outputs, through the engine.
  {
    auto series = [&](Params q, int blocks, float* mn, float* mx, float* max_step, float* out_sig_min, float* out_sig_max) {
      Engine e; e.Setup(48000, 64, 3, false);
      stmlib::Random::Seed(3);
      std::vector<float> oL(64), oR(64), sig_l(64), sig_r(64), s3(64), s4(64);
      const float* in[NUM_INPUTS] = { 0,0,0,0,0,0,0,0,0 };
      float* sigs[kLfoSignals] = { sig_l.data(), sig_r.data(), s3.data(), s4.data() };
      float prev = -1, lo = 9, hi = -9, step = 0, slo = 9, shi = -9;
      for (int n = 0; n < blocks; ++n) {
        e.Process(q, in, oL.data(), oR.data(), 64, nullptr, sigs);
        float vl, vr, ph; e.GetLfo(0, &vl, &vr, &ph);
        if (n > 20) {                      // after the pipeline has settled
          lo = std::min(lo, vl); hi = std::max(hi, vl);
          if (prev >= 0) step = std::max(step, std::fabs(vl - prev));
          prev = vl;
          for (int k = 0; k < 64; ++k) { slo = std::min(slo, sig_l[k]); shi = std::max(shi, sig_l[k]); }
        }
      }
      *mn = lo; *mx = hi; *max_step = step; *out_sig_min = slo; *out_sig_max = shi;
    };
    float lo, hi, st, slo, shi;
    Params q; q.lfo[0].shape = 4; q.lfo[0].rate = 3.0f;                     // square, 3 Hz
    series(q, 2000, &lo, &hi, &st, &slo, &shi);
    f += Check(lo < 0.01f && hi > 0.99f && st > 0.9f, "square LFO: the output jumps from 0 to 1", lo, hi);
    f += Check(slo < 0.01f && shi > 0.99f, "the LFO signal outlet carries the same 0..1 wave (min, max)", slo, shi);
    q.lfo[0].smooth = 100.0f;                                              // 200 ms slew
    series(q, 2000, &lo, &hi, &st, &slo, &shi);
    f += Check(st < 0.1f && hi - lo > 0.3f, "smooth 100: the jump becomes a glide (largest step per call < 0.1)", st, hi - lo);
    Params j; j.lfo[0].shape = 1; j.lfo[0].rate = 0.0f; j.lfo[0].offset = 0.0f;      // frozen ramp at phase 0 (value 0)
    series(j, 1000, &lo, &hi, &st, &slo, &shi);
    f += Check(hi - lo < 1e-5f, "no jitter: a stopped LFO is perfectly still", hi - lo);
    j.lfo[0].jitter = 100.0f;
    series(j, 4000, &lo, &hi, &st, &slo, &shi);
    f += Check(hi - lo > 0.15f && lo >= 0.0f && hi <= 1.0f, "jitter 100: a stopped LFO wobbles randomly (range)", lo, hi);
    // hold freezes, release resumes
    {
      Engine e; e.Setup(48000, 64, 3, false);
      std::vector<float> oL(64), oR(64);
      const float* in[NUM_INPUTS] = { 0,0,0,0,0,0,0,0,0 };
      Params h; h.lfo[0].shape = 1; h.lfo[0].rate = 0.7f;                  // ramp
      float vl, vr, ph, v0, v1;
      for (int n = 0; n < 200; ++n) e.Process(h, in, oL.data(), oR.data(), 64);
      h.lfo[0].hold = 1;
      for (int n = 0; n < 4; ++n) e.Process(h, in, oL.data(), oR.data(), 64);
      e.GetLfo(0, &v0, &vr, &ph);
      for (int n = 0; n < 400; ++n) e.Process(h, in, oL.data(), oR.data(), 64);
      e.GetLfo(0, &v1, &vr, &ph);
      f += Check(std::fabs(v1 - v0) < 1e-6f, "hold: the output stays put while held", v0, v1);
      h.lfo[0].hold = 0;
      for (int n = 0; n < 400; ++n) e.Process(h, in, oL.data(), oR.data(), 64);
      e.GetLfo(0, &vl, &vr, &ph);
      f += Check(std::fabs(vl - v1) > 0.05f, "release: the LFO carries on", v1, vl);
    }
    // x10 and the sync table
    {
      Params x; x.lfo[0].rate = 2.0f; x.lfo[0].x10 = 1;
      Run r = Go(x, 0.5, 0.3);
      f += Check(std::fabs(r.lfo_hz[0] - 20.0f) < 1e-3f, "x10: 2 Hz becomes 20 Hz", r.lfo_hz[0]);
      Params y; y.tempo = 120.0f; y.lfo[0].sync = 1; y.lfo[0].div = 15; y.lfo[1].sync = 1; y.lfo[1].div = 0; y.lfo[2].sync = 1; y.lfo[2].div = 23;
      Run ry = Go(y, 0.5, 0.3);
      f += Check(std::fabs(ry.lfo_hz[0] - 0.5f) < 1e-4f && std::fabs(ry.lfo_hz[1] - 32.0f) < 1e-3f && std::fabs(ry.lfo_hz[2] - 2.0f / 32.0f / 4.0f) < 1e-4f,
                 "sync at 120 BPM: '1' = 0.5 Hz, '1/64' = 32 Hz, '32' = 1/64 Hz", ry.lfo_hz[0], ry.lfo_hz[1]);
    }
    // split: the left and right signals differ; without it they are the same
    {
      Engine e; e.Setup(48000, 64, 3, false);
      std::vector<float> oL(64), oR(64), a(64), b(64), c(64), d(64);
      const float* in[NUM_INPUTS] = { 0,0,0,0,0,0,0,0,0 };
      float* sigs[kLfoSignals] = { a.data(), b.data(), c.data(), d.data() };
      Params q2; q2.lfo[0].rate = 1.0f; q2.lfo[0].split_deg = 120.0f;
      double diff = 0;
      for (int n = 0; n < 800; ++n) { e.Process(q2, in, oL.data(), oR.data(), 64, nullptr, sigs); if (n > 100) for (int k = 0; k < 64; ++k) diff += std::fabs(a[k] - b[k]); }
      f += Check(diff / (700.0 * 64.0) > 0.05, "with a split the left and right LFO signals differ", diff / (700.0 * 64.0));
    }
  }

  // 0b1. The knob is the centre; the amount is how far the LFO travels (the whole range x amount),
  //      clipped at the ends of the range by the engine. A negative amount flips the LFO.
  {
    auto swing = [](int dest, float depth, bool uni, float* at_peak, float* at_trough) {
      beads::GrainModulation g;
      g.shape[0] = beads::LFO_SINE; g.unipolar[dest][0] = uni; g.depth[dest][0] = depth;
      g.cycles[0] = 0.0; *at_peak = g.Offset(dest, 0.0f);     // sine peak
      g.cycles[0] = 0.5; *at_trough = g.Offset(dest, 0.0f);   // sine trough
    };
    float pk, tr;
    swing(beads::MOD_REVERB, 1.0f, false, &pk, &tr);
    f += Check(std::fabs(pk - 0.5f) < 1e-5 && std::fabs(tr + 0.5f) < 1e-5, "+100%: swings +/-half a turn around the knob (the whole range peak to peak)", pk, tr);
    swing(beads::MOD_TIME, 0.5f, false, &pk, &tr);
    f += Check(std::fabs(pk - 0.25f) < 1e-5 && std::fabs(tr + 0.25f) < 1e-5, "+50%: swings +/-a quarter of a turn (half the range peak to peak)", pk, tr);
    swing(beads::MOD_FEEDBACK, -1.0f, false, &pk, &tr);
    f += Check(std::fabs(pk + 0.5f) < 1e-5 && std::fabs(tr - 0.5f) < 1e-5, "-100%: the same swing, upside down", pk, tr);
    swing(beads::MOD_PITCH, 1.0f, false, &pk, &tr);
    f += Check(std::fabs(pk - 24.0f) < 1e-4 && std::fabs(tr + 24.0f) < 1e-4, "pitch: 100% swings +/-24 semitones (the whole -24..+24 range peak to peak)", pk, tr);
    swing(beads::MOD_REVERB, 1.0f, true, &pk, &tr);
    f += Check(std::fabs(pk - 1.0f) < 1e-5 && std::fabs(tr) < 1e-5, "unipolar LFO (optional): 0..+1 turn up from the knob", pk, tr);
  }
  // 0b. Polarity belongs to the matrix cell: the same LFO can drive one destination both ways and another upward only.
  {
    beads::GrainModulation g;
    g.shape[0] = beads::LFO_SINE; g.depth[beads::MOD_REVERB][0] = 1.0f; g.depth[beads::MOD_FEEDBACK][0] = 1.0f;
    g.unipolar[beads::MOD_FEEDBACK][0] = 1;                       // reverb stays +/-, feedback is + only
    g.cycles[0] = 0.0; const float rv_pk = g.Offset(beads::MOD_REVERB, 0.0f), fb_pk = g.Offset(beads::MOD_FEEDBACK, 0.0f);
    g.cycles[0] = 0.5; const float rv_tr = g.Offset(beads::MOD_REVERB, 0.0f), fb_tr = g.Offset(beads::MOD_FEEDBACK, 0.0f);
    f += Check(std::fabs(rv_pk - 0.5f) < 1e-5 && std::fabs(rv_tr + 0.5f) < 1e-5, "same LFO, cell A bipolar: swings -0.5..+0.5", rv_pk, rv_tr);
    f += Check(std::fabs(fb_pk - 1.0f) < 1e-5 && std::fabs(fb_tr) < 1e-5, "same LFO, cell B unipolar: swings 0..+1", fb_pk, fb_tr);
    g.unipolar[beads::MOD_FEEDBACK][0] = 1; g.depth[beads::MOD_FEEDBACK][0] = -1.0f;
    g.cycles[0] = 0.0; const float neg_pk = g.Offset(beads::MOD_FEEDBACK, 0.0f);
    f += Check(std::fabs(neg_pk + 1.0f) < 1e-5, "unipolar with a negative amount goes down instead", neg_pk);
    f += Check(std::fabs(g.Lfo(0, 0.0) - 1.0f) < 1e-5 && std::fabs(g.Lfo(0, 0.5)) < 1e-5,
               "the LFO value itself (and the display readout) is 0..1: 1 at the sine peak, 0 at the trough", g.Lfo(0, 0.0), g.Lfo(0, 0.5));
  }
  {
    Params q; q.density = 0.9f; q.size = 0.2f; q.time = 0.5f; q.lfo[0].rate = 0.3f; q.mod[DEST_TIME][0] = 40.0f;
    Run bi = Go(q, 9.0, 0.5);
    q.uni[DEST_TIME][0] = 1;
    Run un = Go(q, 9.0, 0.5);
    float blo = 1, bhi = 0, ulo = 1, uhi = 0;
    for (auto& e : bi.grains) { blo = std::min(blo, e.time); bhi = std::max(bhi, e.time); }
    for (auto& e : un.grains) { ulo = std::min(ulo, e.time); uhi = std::max(uhi, e.time); }
    f += Check(blo < 0.32f && bhi > 0.68f && blo > 0.25f && bhi < 0.75f, "engine: bipolar cell at 40% swings Time +/-0.2 around the knob", blo, bhi);
    f += Check(ulo > 0.45f && uhi > 0.85f, "engine: unipolar cell only moves Time up from the knob", ulo, uhi);
  }
  {
    Params q; q.density = 0.9f; q.size = 0.2f; q.time = 0.5f; q.lfo[0].rate = 0.3f; q.mod[DEST_TIME][0] = 100.0f;
    Run r = Go(q, 9.0, 0.5);
    float lo = 1, hi = 0;
    for (auto& e : r.grains) { lo = std::min(lo, e.time); hi = std::max(hi, e.time); }
    f += Check(lo < 0.05f && hi > 0.95f, "engine: Time knob centred, bipolar LFO 100% runs exactly from the bottom to the top of the range", lo, hi);
    q.mod[DEST_TIME][0] = 50.0f;
    r = Go(q, 9.0, 0.5);
    lo = 1; hi = 0;
    for (auto& e : r.grains) { lo = std::min(lo, e.time); hi = std::max(hi, e.time); }
    f += Check(lo > 0.2f && lo < 0.3f && hi > 0.7f && hi < 0.8f, "engine: ...and 50% only half way to each end (0.25..0.75)", lo, hi);
  }
  {
    // a Phase split adds a per-grain delta after the block-level clamp; the result must stay inside -24..+24 st
    Params q; q.density = 0.9f; q.size = 0.2f; q.lfo[0].shape = 4; q.lfo[0].rate = 1.0f; q.lfo[0].split_deg = 90.0f; q.mod[DEST_PITCH][0] = 100.0f;
    Run r = Go(q, 8.0, 0.5);
    double mx = 0;
    for (auto& e : r.grains) mx = std::max(mx, std::fabs(12.0 * std::log2((double)e.pitch_ratio)));
    f += Check(r.grains.size() > 30 && mx < 24.01, "engine: square LFO on pitch with a Phase split stays inside +/-24 st", (float)mx);
  }
  // Through the engine: a Time knob at 0.1 with a slow 100% LFO must send grains all the way up to 1 and down to 0.
  {
    Params p = base; p.time = 0.1f; p.lfo[0].rate = 0.3f; p.mod[DEST_TIME][0] = 100.0f;
    Run r = Go(p, 9.0, 0.5);
    float lo = 1.0f, hi = 0.0f;
    for (auto& g : r.grains) { lo = std::min(lo, g.time); hi = std::max(hi, g.time); }
    f += Check(r.grains.size() > 30 && hi > 0.55f && hi < 0.65f && lo < 0.05f, "engine: Time knob at 0.1, bipolar LFO 100%: swings 0.1 +/-0.5, clipped at 0 below and reaching 0.6 above", lo, hi);
  }

  // 1. Nothing assigned: changing LFO settings must not touch the random sequence or any grain.
  {
    Params a = base, b = base;
    b.lfo[0].shape = 3; b.lfo[0].rate = 5.0f; b.lfo[1].split_deg = 120.0f; b.tempo = 90.0f;
    Run ra = Go(a, 3.0), rb = Go(b, 3.0);
    bool same = ra.grains.size() == rb.grains.size() && ra.grains.size() > 20;
    for (size_t i = 0; same && i < ra.grains.size(); ++i)
      same = ra.grains[i].pan == rb.grains[i].pan && ra.grains[i].pitch_ratio == rb.grains[i].pitch_ratio &&
             ra.grains[i].time == rb.grains[i].time && ra.grains[i].shape == rb.grains[i].shape;
    f += Check(same, "empty matrix leaves every grain bit-identical", double(ra.grains.size()), double(rb.grains.size()));
  }

  // 2. Spread: 0 = original behaviour, 1 = grains across the whole stereo field.
  {
    Params a = base, b = base, c = base;
    b.spread = 0.5f; c.spread = 1.0f;
    Run r0 = Go(a, 6.0), r5 = Go(b, 6.0), r1 = Go(c, 6.0);
    auto pans = [](const Run& r) { std::vector<double> v; for (auto& g : r.grains) v.push_back(g.pan); return v; };
    const double s0 = Std(pans(r0)), s5 = Std(pans(r5)), s1 = Std(pans(r1));
    auto lo = [](std::vector<double> v) { return *std::min_element(v.begin(), v.end()); };
    auto hi = [](std::vector<double> v) { return *std::max_element(v.begin(), v.end()); };
    f += Check(s1 > s5 && s5 > s0, "pan spread grows with the Spread knob (std 0 < 0.5 < 1)", s0, s1);
    f += Check(s1 > 0.2 && lo(pans(r1)) < 0.1 && hi(pans(r1)) > 0.9, "Spread 1 reaches both edges of the stereo field", lo(pans(r1)), hi(pans(r1)));
    f += Check(s0 < 0.12, "Spread 0 stays close to the original Beads pan width", s0);
  }

  // 2b. Widening the stereo field must not make the output louder. (Beads' pan law folds the other
  //     input channel into the side a grain is panned to, which used to add about +2.5 dB per channel.)
  {
    Params s0 = base, s1 = base, s5 = base;
    s5.spread = 0.5f; s1.spread = 1.0f;
    const double l0 = LevelDb(s0), l5 = LevelDb(s5), l1 = LevelDb(s1);
    f += Check(std::fabs(l1 - l0) < 1.5 && std::fabs(l5 - l0) < 1.5, "Spread 0.5 / 1 keeps the level within 1.5 dB of Spread 0", l0, l1);
    // Phase alone (a split LFO that is practically not modulating anything) widens the field too.
    Params q0 = base, q1 = base;
    q0.lfo[0].rate = 0.02f; q0.mod[DEST_TIME][0] = 1.0f;
    q1 = q0; q1.lfo[0].split_deg = 180.0f;
    const double p0 = LevelDb(q0), p1 = LevelDb(q1);
    f += Check(std::fabs(p1 - p0) < 1.5, "Phase 180deg keeps the level within 1.5 dB of Phase 0", p0, p1);
    // Dense settings: Beads already pans wide there, so Spread must not change the level much.
    Params d0 = base, d1 = base;
    d0.density = 1.0f; d1.density = 1.0f; d1.spread = 1.0f;
    f += Check(std::fabs(LevelDb(d1) - LevelDb(d0)) < 1.5, "dense: Spread 1 stays within 1.5 dB of Spread 0", LevelDb(d0), LevelDb(d1));
  }

  // 3. A pitch LFO scatters grains (the "spread" of an LFO), none without it.
  {
    Params still = base, lfo = base;
    lfo.lfo[0].rate = 7.0f; lfo.mod[DEST_PITCH][0] = 100.0f;
    Run r0 = Go(still, 6.0), r1 = Go(lfo, 6.0);
    auto semis = [](const Run& r) { std::vector<double> v; for (auto& g : r.grains) v.push_back(Semis(g)); return v; };
    f += Check(Std(semis(r0)) < 0.01, "no LFO: every grain has the same pitch", Std(semis(r0)));
    f += Check(Std(semis(r1)) > 8.0, "pitch LFO at 100% scatters grain pitch (std > 8 st)", Std(semis(r1)));
  }

  // 4. Time LFO, square wave: grains jump to the two extremes.
  {
    Params p = base;
    p.lfo[0].shape = 4; p.lfo[0].rate = 6.0f; p.mod[DEST_TIME][0] = 100.0f;
    Run r = Go(p, 6.0);
    int extreme = 0; for (auto& g : r.grains) extreme += (g.time < 0.1f || g.time > 0.9f);
    f += Check(r.grains.size() > 20 && extreme > 0.9 * r.grains.size(), "square LFO on time sends grains to the two ends", double(extreme), double(r.grains.size()));
  }

  // 5. Stereo split: with grains spread across the field, the phase knob ties pan to LFO phase.
  {
    Params p = base;
    p.spread = 1.0f; p.lfo[0].rate = 0.02f; p.mod[DEST_PITCH][0] = 100.0f;   // slow LFO: the same cycle for the whole run
    Params q = p; q.lfo[0].split_deg = 180.0f;
    // The cosine starts at its peak, so sample the slow LFO a quarter cycle in (11.5 s .. 13.5 s at 0.02 Hz): the slope is steady there.
    auto Mid = [&](Params x) { return Go(x, 13.5, 11.5); };
    Run r0 = Mid(p), r1 = Mid(q);
    auto pans = [](const Run& r) { std::vector<double> v; for (auto& g : r.grains) v.push_back(g.pan); return v; };
    auto semis = [](const Run& r) { std::vector<double> v; for (auto& g : r.grains) v.push_back(Semis(g)); return v; };
    const double c0 = Corr(pans(r0), semis(r0)), c1 = Corr(pans(r1), semis(r1));
    f += Check(std::fabs(c0) < 0.3, "split 0: pan and pitch are unrelated", c0);
    f += Check(std::fabs(c1) > 0.8, "split 180deg: pitch follows pan across the stereo field", c1);
    Params w = q; w.lfo[0].split_deg = 0.0f; w.spread = 0.0f;
    Run rw = Mid(w);
    std::vector<double> idx; for (size_t i = 0; i < rw.grains.size(); ++i) idx.push_back(double(i));
    f += Check(rw.grains.size() > 20 && std::fabs(Corr(idx, semis(rw))) > 0.95,
               "split 0, spread 0: pitch follows time only (all grains move together)", Corr(idx, semis(rw)));

    // Phase ALONE (Spread 0) must create the stereo split: grains spread across the field and the
    // left/right edges hear opposite phases.
    Params s = p; s.spread = 0.0f; s.lfo[0].split_deg = 180.0f;
    Run rs = Mid(s);
    f += Check(std::fabs(Corr(pans(rs), semis(rs))) > 0.8, "Spread 0, split 180deg: pitch still follows pan (Phase alone splits)", Corr(pans(rs), semis(rs)));
    f += Check(Std(pans(rs)) > 0.25, "Spread 0, split 180deg: grains spread across the stereo field", Std(pans(rs)));
    // Half the split, half the width; and the extremes still hear the full +/- split/2.
    Params h = s; h.lfo[0].split_deg = 90.0f;
    Run rh = Mid(h);
    f += Check(Std(pans(rh)) > 0.1 && Std(pans(rh)) < Std(pans(rs)), "split 90deg: narrower field than 180deg", Std(pans(rh)), Std(pans(rs)));
    // (a narrower field lets Beads' own random pan jitter matter more, so the bar is lower)
    f += Check(std::fabs(Corr(pans(rh), semis(rh))) > 0.6, "split 90deg: pitch still follows pan", Corr(pans(rh), semis(rh)));
    // An LFO that feeds nothing per grain does not move the grains, whatever its split.
    // (Reverb: unlike density or size it does not change trigger regularity or grain overlap,
    //  which would change Beads' own pan width.)
    Params u = base; u.lfo[0].split_deg = 180.0f; u.mod[DEST_REVERB][0] = 50.0f;
    Run ru = Go(u, 5.0), rb0 = Go(base, 5.0);
    f += Check(std::fabs(Std(pans(ru)) - Std(pans(rb0))) < 0.05, "a split LFO that only feeds reverb does not spread the grains", Std(pans(ru)), Std(pans(rb0)));
  }

  // 6. Modulation by itself does not widen the pan: with split 0 the stereo field is untouched
  //    (only the Phase knob, or Spread, widens it). Size and density are left out on purpose: they
  //    change how many grains overlap / how regular the triggers are, and Beads' own pan width
  //    (0.5 x active grains x spread) follows those.
  {
    Params a = base, b = base, c = base;
    b.lfo[0].rate = 3.0f; b.lfo[0].split_deg = 0.0f;
    const int dests[] = { DEST_TIME, DEST_SHAPE, DEST_PITCH };
    for (int d : dests) b.mod[d][0] = 100.0f;
    c.lfo[0].rate = 3.0f; c.mod[DEST_SIZE][0] = 100.0f;
    Run ra = Go(a, 5.0), rb = Go(b, 5.0), rc = Go(c, 5.0);
    auto pans = [](const Run& r) { std::vector<double> v; for (auto& g : r.grains) v.push_back(g.pan); return v; };
    f += Check(std::fabs(Std(pans(ra)) - Std(pans(rb))) < 0.05, "modulating time/shape/pitch leaves the pan width unchanged", Std(pans(ra)), Std(pans(rb)));
    // Informational: the size case, to document where the extra width comes from.
    std::vector<double> dur_a, dur_c;
    for (auto& g : ra.grains) dur_a.push_back(g.duration);
    for (auto& g : rc.grains) dur_c.push_back(g.duration);
    f += Check(Std(dur_c) > 5 * Std(dur_a) + 1e-6, "size LFO changes grain lengths (so overlap, so Beads' own pan width)", Std(dur_a), Std(dur_c));
  }

  // 7. Readouts, reset, and tempo sync.
  {
    Params p = base; p.lfo[0].rate = 0.5f;
    Run r = Go(p, 1.0, 5.0);
    f += Check(std::fabs(r.lfo_phase[0] - 0.5f) < 0.03f, "readout phase after 1 s at 0.5 Hz is about 0.5", r.lfo_phase[0]);

    stmlib::Random::Seed(1);
    Engine e; e.Setup(48000, 64, 3, false);
    Params q = base; q.lfo[0].rate = 0.4f; q.lfo[0].split_deg = 90.0f;     // (not 0.5 Hz: after 1 s that sits on the cosine's symmetric trough)
    std::vector<float> oL(64), oR(64); const float* in[NUM_INPUTS] = { 0,0,0,0,0,0,0,0,0 };
    for (int n = 0; n < 48000; n += 64) e.Process(q, in, oL.data(), oR.data(), 64);
    float vl, vr, ph; e.GetLfo(0, &vl, &vr, &ph);
    f += Check(std::fabs(vl - vr) > 0.1f, "with a split the left and right edges see different LFO values", vl, vr);
    q.lfo[0].reset = 1;
    e.Process(q, in, oL.data(), oR.data(), 64);
    e.GetLfo(0, &vl, &vr, &ph);
    f += Check(ph < 0.01f, "changing the reset counter restarts the cycle", ph);

    // synced: 120 BPM, 1/4 note = 2 Hz, 1/1 = 0.5 Hz
    auto wraps = [&](long div) {
      Engine s; s.Setup(48000, 64, 3, false);
      Params t = base; t.tempo = 120.0f; t.lfo[0].sync = 1; t.lfo[0].div = div; t.lfo[0].rate = 9.0f;
      float prev = 0, v, w2, php; int count = 0;
      for (int n = 0; n < 96000; n += 64) {
        s.Process(t, in, oL.data(), oR.data(), 64); s.GetLfo(0, &v, &w2, &php);
        if (php < prev - 0.5f) ++count; prev = php;
      }
      return count;
    };
    // the speed the display scales its waveform by: the knob in Hz mode, the tempo-derived rate when synced
    {
      Params h = base; h.lfo[0].rate = 2.5f; h.lfo[1].rate = 7.0f;
      h.lfo[2].sync = 1; h.lfo[2].div = 9; h.lfo[3].sync = 1; h.lfo[3].div = 15; h.tempo = 90.0f;
      Run rh = Go(h, 1.0, 0.5);
      f += Check(std::fabs(rh.lfo_hz[0] - 2.5f) < 1e-4f && std::fabs(rh.lfo_hz[1] - 7.0f) < 1e-4f,
                 "reported speed follows the Rate knob in Hz mode (2.5 and 7 Hz)", rh.lfo_hz[0], rh.lfo_hz[1]);
      f += Check(std::fabs(rh.lfo_hz[2] - 1.5f) < 1e-4f && std::fabs(rh.lfo_hz[3] - 0.375f) < 1e-4f,
                 "reported speed when synced at 90 BPM: 1/4 = 1.5 Hz, 1/1 = 0.375 Hz", rh.lfo_hz[2], rh.lfo_hz[3]);
    }
    f += Check(wraps(9) == 4, "synced 1/4 at 120 BPM: 4 cycles in 2 s", wraps(9));
    f += Check(wraps(15) == 1, "synced 1/1 at 120 BPM: 1 cycle in 2 s", wraps(15));
    f += Check(wraps(6) == 8, "synced 1/8 at 120 BPM: 8 cycles in 2 s", wraps(6));
  }
  return f;
}

}  // namespace

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
  // Regression: delay mode + freeze + a seed clock faster than 16 codec samples
  // used to divide by zero in DelayController (SIGFPE under Rosetta).
  for (int media = 0; media < 4; ++media) for (int period : { 4, 8, 15, 16, 40 }) {
    const double sr = 48000; const int vs = 64;
    Engine e; e.Setup(sr, vs, media, false);
    Params p; p.size = 1.0f; p.density = 0.7f; p.freeze = 1; p.dry_wet = 1.0f;
    std::vector<float> seed(vs), oL(vs), oR(vs);
    bool nan = false; long n = 0;
    for (int blk = 0; blk < int(sr * 3) / vs; ++blk) {
      for (int i = 0; i < vs; ++i, ++n) seed[i] = (n % period == 0) ? 1.0f : 0.0f;
      const float* in[NUM_INPUTS] = { 0,0,0,0,0,0,0, seed.data(), 0 };
      e.Process(p, in, oL.data(), oR.data(), vs);
      for (int i = 0; i < vs; ++i) if (!std::isfinite(oL[i])) nan = true;
    }
    printf("freeze+fast seed clock media=%d period=%d %s\n", media, period, nan ? "FAIL" : "OK");
    fails += nan;
  }
  fails += TestModulation();
  fails += TestLevelControl();
  fails += TestDelaySpread();
  printf("%d failures\n", fails);
  return fails != 0;
}
