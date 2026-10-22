// portieres~ : Max port of Mutable Instruments Beads (granular processor).
// DSP (c) 2017 Emilie Gillet, MIT license. Max glue for this port.
#include "ext.h"
#include "ext_obex.h"
#include "ext_itm.h"
#include "z_dsp.h"

#include <atomic>
#include <cmath>
#include <cstring>

#include "ext/engine.h"

using namespace beads_max;

typedef struct _beads {
  t_pxobject ob;
  Engine* engine;
  Params params;
  long media;          // 0 dirty tape, 1 clean tape, 2 vintage digital, 3 digital
  long force_mono;
  long connected[NUM_INPUTS];
  double sr;
  long vec;
  long reconfigure;    // consumed by the audio thread
  void* grain_out;     // message outlet 3: "grain ..." list per grain
  void* lfo_out;       // message outlet 4: "lfo <n> <valueL> <valueR> <phase>" on `poll`
  t_clock* clock;      // drains grain events on the scheduler thread
  std::atomic<int>* clock_pending;
  double tempo_attr;                 // 0 = follow the host (Live) tempo
  std::atomic<double>* host_tempo;   // refreshed on `poll`
} t_beads;

static t_class* s_beads_class = nullptr;

extern "C" {
void* beads_new(t_symbol* s, long argc, t_atom* argv);
void beads_free(t_beads* x);
void beads_assist(t_beads* x, void* b, long m, long a, char* s);
void beads_dsp64(t_beads* x, t_object* dsp64, short* count, double samplerate,
                 long maxvectorsize, long flags);
void beads_perform64(t_beads* x, t_object* dsp64, double** ins, long numins,
                     double** outs, long numouts, long sampleframes, long flags,
                     void* userparam);
t_max_err beads_media_set(t_beads* x, void* attr, long argc, t_atom* argv);
t_max_err beads_mono_set(t_beads* x, void* attr, long argc, t_atom* argv);
void beads_reset(t_beads* x);
void beads_drain(t_beads* x);
void beads_lfo(t_beads* x, t_symbol* s, long argc, t_atom* argv);
void beads_amt(t_beads* x, t_symbol* s, long argc, t_atom* argv);
void beads_pol(t_beads* x, t_symbol* s, long argc, t_atom* argv);
void beads_poll(t_beads* x);
C74_EXPORT void ext_main(void* r);
}

void ext_main(void* r) {
  t_class* c = class_new("portieres~", (method)beads_new, (method)beads_free,
                         (long)sizeof(t_beads), 0L, A_GIMME, 0);
  class_addmethod(c, (method)beads_dsp64, "dsp64", A_CANT, 0);
  class_addmethod(c, (method)beads_assist, "assist", A_CANT, 0);
  class_addmethod(c, (method)beads_reset, "reset", 0);
  // LFO bank: lfo <1-4> <shape|rate|sync|div|split|uni|reset> [value]
  class_addmethod(c, (method)beads_lfo, "lfo", A_GIMME, 0);
  // Matrix cell: amt <time|size|shape|pitch|density|feedback|reverb|drywet> <1-4> <percent>
  class_addmethod(c, (method)beads_amt, "amt", A_GIMME, 0);
  class_addmethod(c, (method)beads_pol, "pol", A_GIMME, 0);
  // Refreshes the host tempo and reports every LFO on outlet 4
  class_addmethod(c, (method)beads_poll, "poll", 0);

  // Params live in a nested struct: use offsetof via the struct member names.
  CLASS_ATTR_FLOAT(c, "time", 0, t_beads, params.time);
  CLASS_ATTR_FILTER_CLIP(c, "time", 0., 1.);
  CLASS_ATTR_LABEL(c, "time", 0, "Time / Position");
  CLASS_ATTR_FLOAT(c, "time_amt", 0, t_beads, params.time_amt);
  CLASS_ATTR_FILTER_CLIP(c, "time_amt", -1., 1.);
  CLASS_ATTR_FLOAT(c, "size", 0, t_beads, params.size);
  CLASS_ATTR_FILTER_CLIP(c, "size", 0., 1.);
  CLASS_ATTR_LABEL(c, "size", 0, "Size (above 0.99: delay mode)");
  CLASS_ATTR_FLOAT(c, "size_amt", 0, t_beads, params.size_amt);
  CLASS_ATTR_FILTER_CLIP(c, "size_amt", -1., 1.);
  CLASS_ATTR_FLOAT(c, "shape", 0, t_beads, params.shape);
  CLASS_ATTR_FILTER_CLIP(c, "shape", 0., 1.);
  CLASS_ATTR_FLOAT(c, "shape_amt", 0, t_beads, params.shape_amt);
  CLASS_ATTR_FILTER_CLIP(c, "shape_amt", -1., 1.);
  CLASS_ATTR_FLOAT(c, "pitch", 0, t_beads, params.pitch);
  CLASS_ATTR_FILTER_CLIP(c, "pitch", -24., 24.);
  CLASS_ATTR_LABEL(c, "pitch", 0, "Pitch (semitones)");
  CLASS_ATTR_FLOAT(c, "pitch_amt", 0, t_beads, params.pitch_amt);
  CLASS_ATTR_FILTER_CLIP(c, "pitch_amt", -1., 1.);
  CLASS_ATTR_FLOAT(c, "density", 0, t_beads, params.density);
  CLASS_ATTR_FILTER_CLIP(c, "density", 0., 1.);
  CLASS_ATTR_FLOAT(c, "feedback", 0, t_beads, params.feedback);
  CLASS_ATTR_FILTER_CLIP(c, "feedback", 0., 1.);
  CLASS_ATTR_FLOAT(c, "drywet", 0, t_beads, params.dry_wet);
  CLASS_ATTR_FILTER_CLIP(c, "drywet", 0., 1.);
  CLASS_ATTR_FLOAT(c, "reverb", 0, t_beads, params.reverb);
  CLASS_ATTR_FILTER_CLIP(c, "reverb", 0., 1.);
  CLASS_ATTR_FLOAT(c, "gain", 0, t_beads, params.gain);
  CLASS_ATTR_FILTER_CLIP(c, "gain", 0., 40.);
  CLASS_ATTR_LONG(c, "seed", 0, t_beads, params.seed_button);
  CLASS_ATTR_FILTER_CLIP(c, "seed", 0, 2);
  CLASS_ATTR_LABEL(c, "seed", 0, "Seed button (0 off, 1 on, 2 locked)");
  CLASS_ATTR_LONG(c, "freeze", 0, t_beads, params.freeze);
  CLASS_ATTR_STYLE_LABEL(c, "freeze", 0, "onoff", "Freeze");
  CLASS_ATTR_LONG(c, "gateout", 0, t_beads, params.gate_out);
  CLASS_ATTR_STYLE_LABEL(c, "gateout", 0, "onoff", "Right output = trigger gate");

  CLASS_ATTR_FLOAT(c, "spread", 0, t_beads, params.spread);
  CLASS_ATTR_FILTER_CLIP(c, "spread", 0., 1.);
  CLASS_ATTR_LABEL(c, "spread", 0, "Stereo spread: extra random pan width (0 = original Beads)");
  CLASS_ATTR_LONG(c, "wetcap", 0, t_beads, params.wetcap);
  CLASS_ATTR_STYLE_LABEL(c, "wetcap", 0, "onoff", "Level cap: hold the wet path to a set level above the input");
  CLASS_ATTR_FILTER_CLIP(c, "wetcap", 0, 1);
  CLASS_ATTR_FLOAT(c, "wetcap_db", 0, t_beads, params.wetcap_db);
  CLASS_ATTR_FILTER_CLIP(c, "wetcap_db", 0., 24.);
  CLASS_ATTR_LABEL(c, "wetcap_db", 0, "Level cap: dB above the input level the wet path may reach");
  CLASS_ATTR_LONG(c, "overlap", 0, t_beads, params.overlap);
  CLASS_ATTR_STYLE_LABEL(c, "overlap", 0, "onoff", "Stronger overlap scaling");
  CLASS_ATTR_FILTER_CLIP(c, "overlap", 0, 1);
  CLASS_ATTR_FLOAT(c, "overlap_amt", 0, t_beads, params.overlap_amt);
  CLASS_ATTR_FILTER_CLIP(c, "overlap_amt", 0., 1.);
  CLASS_ATTR_LABEL(c, "overlap_amt", 0, "Overlap scaling amount (0 = original 1/sqrt(n), 1 = 1/n)");
  CLASS_ATTR_DOUBLE(c, "tempo", 0, t_beads, tempo_attr);
  CLASS_ATTR_FILTER_CLIP(c, "tempo", 0., 999.);
  CLASS_ATTR_LABEL(c, "tempo", 0, "BPM for synced LFOs (0 = follow the host tempo)");

  CLASS_ATTR_LONG(c, "media", 0, t_beads, media);
  CLASS_ATTR_ENUMINDEX(c, "media", 0, "\"dirty tape\" \"clean tape\" \"vintage digital\" digital");
  CLASS_ATTR_ACCESSORS(c, "media", NULL, beads_media_set);
  CLASS_ATTR_LABEL(c, "media", 0, "Media");
  CLASS_ATTR_LONG(c, "mono", 0, t_beads, force_mono);
  CLASS_ATTR_STYLE_LABEL(c, "mono", 0, "onoff", "Force mono delay buffer");
  CLASS_ATTR_ACCESSORS(c, "mono", NULL, beads_mono_set);

  // Defaults (hardware-like).
  CLASS_ATTR_DEFAULT(c, "time", 0, "0.5");
  CLASS_ATTR_DEFAULT(c, "size", 0, "0.5");
  CLASS_ATTR_DEFAULT(c, "shape", 0, "0.5");
  CLASS_ATTR_DEFAULT(c, "density", 0, "0.7");
  CLASS_ATTR_DEFAULT(c, "drywet", 0, "0.5");
  CLASS_ATTR_DEFAULT(c, "gain", 0, "1.");
  CLASS_ATTR_DEFAULT(c, "media", 0, "3");
  CLASS_ATTR_DEFAULT(c, "wetcap", 0, "1");
  CLASS_ATTR_DEFAULT(c, "wetcap_db", 0, "3.");
  CLASS_ATTR_DEFAULT(c, "overlap", 0, "0");
  CLASS_ATTR_DEFAULT(c, "overlap_amt", 0, "1.");

  class_dspinit(c);
  class_register(CLASS_BOX, c);
  s_beads_class = c;
}

void* beads_new(t_symbol* s, long argc, t_atom* argv) {
  t_beads* x = (t_beads*)object_alloc(s_beads_class);
  if (!x) return nullptr;
  dsp_setup((t_pxobject*)x, NUM_INPUTS);
  // Outlets are created right to left. Outlets 0-3 keep their positions.
  x->lfo_out = outlet_new((t_object*)x, NULL);    // 4: LFO values (on `poll`)
  x->grain_out = outlet_new((t_object*)x, NULL);  // 3: grain messages
  outlet_new((t_object*)x, "signal");             // 2: grain trigger impulses
  outlet_new((t_object*)x, "signal");             // 1: out R / gate
  outlet_new((t_object*)x, "signal");             // 0: out L
  x->ob.z_misc |= Z_NO_INPLACE;  // separate in/out buffers (we read late)
  x->engine = new Engine();
  x->clock_pending = new std::atomic<int>(0);
  x->host_tempo = new std::atomic<double>(120.0);
  x->tempo_attr = 0.0;
  x->clock = (t_clock*)clock_new((t_object*)x, (method)beads_drain);
  x->params = Params();
  x->media = 3;
  x->force_mono = 0;
  x->sr = sys_getsr();
  if (x->sr <= 0) x->sr = 48000;
  x->vec = 64;
  x->reconfigure = 1;
  for (int i = 0; i < NUM_INPUTS; ++i) x->connected[i] = 0;
  attr_args_process(x, (short)argc, argv);
  return x;
}

void beads_free(t_beads* x) {
  dsp_free((t_pxobject*)x);
  if (x->clock) {
    clock_unset(x->clock);
    object_free(x->clock);
    x->clock = nullptr;
  }
  delete x->engine;
  x->engine = nullptr;
  delete x->clock_pending;
  x->clock_pending = nullptr;
  delete x->host_tempo;
  x->host_tempo = nullptr;
}

void beads_assist(t_beads* x, void* b, long m, long a, char* s) {
  static const char* in_names[NUM_INPUTS] = {
    "(signal) Audio L", "(signal) Audio R (unpatched = mono)",
    "(signal) Time CV", "(signal) Size CV", "(signal) Shape CV",
    "(signal) Pitch CV (semitones)", "(signal) Density CV",
    "(signal) Seed gate", "(signal) Freeze gate" };
  if (m == ASSIST_INLET) strncpy_zero(s, in_names[a], 256);
  else {
    static const char* out_names[5] = {
      "(signal) Out L", "(signal) Out R / gate",
      "(signal) Grain trigger (1-sample impulse per grain)",
      "grain <time> <pitch st> <dur ms> <shape> <amp> <pan> <reverse>",
      "lfo <1-4> <value at left edge> <value at right edge> <phase 0-1> <speed in Hz> (one per LFO, on `poll`)" };
    strncpy_zero(s, out_names[a], 256);
  }
}

t_max_err beads_media_set(t_beads* x, void* attr, long argc, t_atom* argv) {
  if (argc && argv) {
    long m = atom_getlong(argv);
    x->media = m < 0 ? 0 : (m > 3 ? 3 : m);
    x->reconfigure = 1;
  }
  return MAX_ERR_NONE;
}

t_max_err beads_mono_set(t_beads* x, void* attr, long argc, t_atom* argv) {
  if (argc && argv) {
    x->force_mono = atom_getlong(argv) != 0;
    x->reconfigure = 1;
  }
  return MAX_ERR_NONE;
}

void beads_reset(t_beads* x) { x->reconfigure = 1; }

// lfo <1-4> <param> [value]
void beads_lfo(t_beads* x, t_symbol* s, long argc, t_atom* argv) {
  if (argc < 2 || atom_gettype(argv + 1) != A_SYM) {
    object_error((t_object*)x, "lfo: expected  lfo <1-4> <param> [value]");
    return;
  }
  const long n = atom_getlong(argv);
  if (n < 1 || n > kNumLfos) {
    object_error((t_object*)x, "lfo: LFO number must be 1-%d", (int)kNumLfos);
    return;
  }
  LfoParams& l = x->params.lfo[n - 1];
  const char* what = atom_getsym(argv + 1)->s_name;
  const double v = argc >= 3 ? atom_getfloat(argv + 2) : 0.0;
  auto clampl = [](long a, long lo, long hi) { return a < lo ? lo : (a > hi ? hi : a); };
  if (!strcmp(what, "shape")) l.shape = clampl((long)std::lround(v), 0, 6);
  else if (!strcmp(what, "rate")) l.rate = (float)(v < 0 ? 0 : v);
  else if (!strcmp(what, "sync")) l.sync = v != 0;
  else if (!strcmp(what, "div")) l.div = clampl((long)std::lround(v), 0, 17);
  else if (!strcmp(what, "split")) l.split_deg = (float)(v < 0 ? 0 : (v > 360 ? 360 : v));
  else if (!strcmp(what, "uni"))                    // legacy: polarity of every cell of this LFO
    for (int d = 0; d < NUM_DESTS; ++d) x->params.uni[d][n - 1] = v != 0;
  else if (!strcmp(what, "reset")) l.reset += 1;    // any change restarts the cycle
  else object_error((t_object*)x, "lfo: unknown parameter '%s'", what);
}

// amt <dest> <1-4> <percent>
void beads_amt(t_beads* x, t_symbol* s, long argc, t_atom* argv) {
  static const char* kDest[NUM_DESTS] = { "time", "size", "shape", "pitch",
                                          "density", "feedback", "reverb", "drywet" };
  if (argc < 3 || atom_gettype(argv) != A_SYM) {
    object_error((t_object*)x, "amt: expected  amt <dest> <1-4> <percent>");
    return;
  }
  const char* name = atom_getsym(argv)->s_name;
  int dest = -1;
  for (int d = 0; d < NUM_DESTS; ++d) if (!strcmp(name, kDest[d])) dest = d;
  const long n = atom_getlong(argv + 1);
  if (dest < 0 || n < 1 || n > kNumLfos) {
    object_error((t_object*)x, "amt: bad destination '%s' or LFO %ld", name, n);
    return;
  }
  double pct = atom_getfloat(argv + 2);
  pct = pct < -100 ? -100 : (pct > 100 ? 100 : pct);
  x->params.mod[dest][n - 1] = (float)pct;
}

// pol <dest> <1-4> <0|1>: polarity of one matrix cell, 1 = bipolar +/- (the default), 0 = unipolar +
void beads_pol(t_beads* x, t_symbol* s, long argc, t_atom* argv) {
  static const char* kDest[NUM_DESTS] = { "time", "size", "shape", "pitch",
                                          "density", "feedback", "reverb", "drywet" };
  if (argc < 3 || atom_gettype(argv) != A_SYM) {
    object_error((t_object*)x, "pol: expected  pol <dest> <1-4> <0|1>");
    return;
  }
  const char* name = atom_getsym(argv)->s_name;
  int dest = -1;
  for (int d = 0; d < NUM_DESTS; ++d) if (!strcmp(name, kDest[d])) dest = d;
  const long n = atom_getlong(argv + 1);
  if (dest < 0 || n < 1 || n > kNumLfos) {
    object_error((t_object*)x, "pol: bad destination '%s' or LFO %ld", name, n);
    return;
  }
  x->params.uni[dest][n - 1] = atom_getfloat(argv + 2) != 0 ? 0 : 1;
}

// Refreshes the host tempo, then reports every LFO: lfo <n> <valueL> <valueR> <phase> <hz>
void beads_poll(t_beads* x) {
  if (!x->engine) return;
  const double bpm = itm_gettempo((t_itm*)itm_getglobal());
  if (bpm > 0) x->host_tempo->store(bpm);
  for (int i = 0; i < kNumLfos; ++i) {
    float vl, vr, ph, hz;
    x->engine->GetLfo(i, &vl, &vr, &ph, &hz);
    t_atom a[5];
    atom_setlong(a + 0, i + 1);
    atom_setfloat(a + 1, vl);
    atom_setfloat(a + 2, vr);
    atom_setfloat(a + 3, ph);
    atom_setfloat(a + 4, hz);
    outlet_anything(x->lfo_out, gensym("lfo"), 5, a);
  }
}

// Scheduler thread: turn queued grain events into "grain" messages.
void beads_drain(t_beads* x) {
  if (!x->engine) return;
  x->clock_pending->store(0);
  GrainEvent ev[64];
  size_t n;
  while ((n = x->engine->PopGrains(ev, 64)) > 0) {
    for (size_t i = 0; i < n; ++i) {
      t_atom a[7];
      atom_setfloat(a + 0, ev[i].time);
      atom_setfloat(a + 1, 12.0 * std::log2((double)ev[i].pitch_ratio));
      atom_setfloat(a + 2, ev[i].duration * 1000.0);
      atom_setfloat(a + 3, ev[i].shape);
      atom_setfloat(a + 4, ev[i].amplitude);
      atom_setfloat(a + 5, ev[i].pan);
      atom_setlong(a + 6, ev[i].reverse ? 1 : 0);
      outlet_anything(x->grain_out, gensym("grain"), 7, a);
    }
  }
}

void beads_dsp64(t_beads* x, t_object* dsp64, short* count, double samplerate,
                 long maxvectorsize, long flags) {
  for (int i = 0; i < NUM_INPUTS; ++i) x->connected[i] = count[i];
  x->sr = samplerate;
  x->vec = maxvectorsize;
  x->reconfigure = 1;
  object_method(dsp64, gensym("dsp_add64"), x, beads_perform64, 0, NULL);
}

void beads_perform64(t_beads* x, t_object* dsp64, double** ins, long numins,
                     double** outs, long numouts, long sampleframes, long flags,
                     void* userparam) {
  if (x->ob.z_disabled || !x->engine) return;

  if (x->reconfigure) {
    x->reconfigure = 0;
    const bool mono = x->force_mono || !x->connected[IN_R];
    x->engine->Setup(x->sr, (int)x->vec, (int)x->media, mono);
  }

  // Convert doubles to floats on the stack-sized chunks.
  const long kChunk = 4096;
  float buf[NUM_INPUTS][kChunk];
  float out_l[kChunk], out_r[kChunk], out_trig[kChunk];
  for (long base = 0; base < sampleframes; base += kChunk) {
    const long n = sampleframes - base < kChunk ? sampleframes - base : kChunk;
    const float* in[NUM_INPUTS];
    for (int i = 0; i < NUM_INPUTS; ++i) {
      if (x->connected[i] && i < numins) {
        for (long k = 0; k < n; ++k) buf[i][k] = (float)ins[i][base + k];
        in[i] = buf[i];
      } else {
        in[i] = nullptr;
      }
    }
    Params p = x->params;
    p.tempo = x->tempo_attr > 0 ? (float)x->tempo_attr : (float)x->host_tempo->load();
    x->engine->Process(p, in, out_l, out_r, (size_t)n,
                       numouts > 2 ? out_trig : nullptr);
    for (long k = 0; k < n; ++k) {
      outs[0][base + k] = out_l[k];
      outs[1][base + k] = out_r[k];
      if (numouts > 2) outs[2][base + k] = out_trig[k];
    }
  }

  if (x->engine->HasGrains() && x->clock_pending->exchange(1) == 0) {
    clock_delay(x->clock, 0);
  }
}
