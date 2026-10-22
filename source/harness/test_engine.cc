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

struct Run { std::vector<GrainEvent> grains; float lfo_phase[kNumLfos], lfo_l[kNumLfos], lfo_r[kNumLfos]; };

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
  for (int i = 0; i < kNumLfos; ++i) e.GetLfo(i, &r.lfo_l[i], &r.lfo_r[i], &r.lfo_phase[i]);
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

int Check(bool ok, const char* what, double a = 0, double b = 0) {
  printf("mod   %-62s %s  (%.3f, %.3f)\n", what, ok ? "OK" : "FAIL", a, b);
  return ok ? 0 : 1;
}

int TestModulation() {
  int f = 0;
  Params base; base.density = 0.9f; base.size = 0.2f;

  // The LFO shapes themselves (pure maths).
  {
    beads::GrainModulation g;
    g.shape[0] = beads::LFO_SINE; g.cycles[0] = 0.25;
    f += Check(std::fabs(g.Lfo(0, 0.0) - 1.0f) < 1e-5, "sine peaks at a quarter cycle", g.Lfo(0, 0.0));
    g.depth[beads::MOD_PITCH][0] = 1.0f;
    f += Check(std::fabs(g.Offset(beads::MOD_PITCH, 0.0f) - 24.0f) < 1e-3, "+100% on pitch sweeps 24 semitones", g.Offset(beads::MOD_PITCH, 0.0f));
    f += Check(g.GrainDelta(beads::MOD_PITCH, 1.0f) == 0.0f, "split 0: a grain differs from the centre by exactly 0");
    g.split[0] = 0.5f;   // 180 degrees
    g.cycles[0] = 0.0;
    f += Check(std::fabs(g.GrainDelta(beads::MOD_PITCH, 1.0f) - 24.0f * std::sin(6.2831853f * 0.25f)) < 1e-3, "split 180deg: hard right sees +90deg, hard left -90deg", g.GrainDelta(beads::MOD_PITCH, 1.0f));
    f += Check(std::fabs(g.GrainDelta(beads::MOD_PITCH, -1.0f) + g.GrainDelta(beads::MOD_PITCH, 1.0f)) < 1e-3, "left and right deltas are mirror images");
    g.shape[0] = beads::LFO_RANDOM_HOLD; g.split[0] = 0.0f;
    f += Check(g.Lfo(0, 0.0) == g.Lfo(0, 0.4), "random hold is constant within a cycle");
    f += Check(g.Lfo(0, 0.0) != g.Lfo(0, 1.0), "random hold changes between cycles");
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
    Run r0 = Go(p, 5.0), r1 = Go(q, 5.0);
    auto pans = [](const Run& r) { std::vector<double> v; for (auto& g : r.grains) v.push_back(g.pan); return v; };
    auto semis = [](const Run& r) { std::vector<double> v; for (auto& g : r.grains) v.push_back(Semis(g)); return v; };
    const double c0 = Corr(pans(r0), semis(r0)), c1 = Corr(pans(r1), semis(r1));
    f += Check(std::fabs(c0) < 0.3, "split 0: pan and pitch are unrelated", c0);
    f += Check(c1 > 0.8, "split 180deg: pitch follows pan across the stereo field", c1);
    Params w = q; w.lfo[0].split_deg = 0.0f; w.spread = 0.0f;
    Run rw = Go(w, 5.0);
    std::vector<double> idx; for (size_t i = 0; i < rw.grains.size(); ++i) idx.push_back(double(i));
    f += Check(rw.grains.size() > 20 && Corr(idx, semis(rw)) > 0.95,
               "split 0, spread 0: pitch follows time only (all grains move together)", Corr(idx, semis(rw)));
  }

  // 6. Modulation does not widen the pan (Phase alone sets the stereo split). Size and density are
  //    left out on purpose: they change how many grains overlap / how regular the triggers are, and
  //    Beads' own pan width (0.5 x active grains x spread) follows those.
  {
    Params a = base, b = base, c = base;
    b.lfo[0].rate = 3.0f; b.lfo[0].split_deg = 180.0f;
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
    Params q = base; q.lfo[0].rate = 0.5f; q.lfo[0].split_deg = 90.0f;
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
    f += Check(wraps(7) == 4, "synced 1/4 at 120 BPM: 4 cycles in 2 s", wraps(7));
    f += Check(wraps(13) == 1, "synced 1/1 at 120 BPM: 1 cycle in 2 s", wraps(13));
    f += Check(wraps(4) == 8, "synced 1/8 at 120 BPM: 8 cycles in 2 s", wraps(4));
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
  printf("%d failures\n", fails);
  return fails != 0;
}
