// grain_scope.js -- v8ui script for portieres~
//
// Scrolling scope of what the attenuverters / randomizers actually produce:
// one lane per grain parameter, one dot per grain, newest at the right.
//   - dot           a grain (brightness = amplitude, ring = reversed)
//   - dashed line   the knob's base value (if you send one)
//   - shaded strip  min..max of the visible window, so the spread is obvious
//
// Wire portieres~ outlet 3 straight into this v8ui.
//
// Messages:
//   grain <time> <pitch st> <dur ms> <shape> <amp> <pan> <reverse>
//   base <lane> <value>   lane = time | pitch | dur | shape | amp | pan
//                         (value in the lane's own units; "base pitch 0")
//   window <seconds>      visible history (default 6)
//   clear

mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;
inlets = 1;
outlets = 0;

// lo/hi: fixed axis range. log: log axis (duration).
var LANES = [
  { id: "time",  label: "time",   lo: 0,   hi: 1,    fmt: 2 },
  { id: "pitch", label: "pitch",  lo: -24, hi: 24,   fmt: 1, unit: " st" },
  { id: "dur",   label: "dur",    lo: 5,   hi: 4000, fmt: 0, unit: " ms", log: true },
  { id: "shape", label: "shape",  lo: 0,   hi: 1,    fmt: 2 },
  { id: "amp",   label: "amp",    lo: 0,   hi: 1.5,  fmt: 2 },
  { id: "pan",   label: "pan",    lo: 0,   hi: 1,    fmt: 2 }
];
var IDX = { time: 0, pitch: 1, dur: 2, shape: 3, amp: 4, pan: 5 };

var window_s = 6;
var MAX_GRAINS = 1500;
var grains = [];                       // {t, v:[6], rev}
var bases = [null, null, null, null, null, null];

function window(s) { window_s = Math.max(0.5, s); }
function clear() { grains = []; mgraphics.redraw(); }

function base(lane, v) {
  var i = IDX[lane];
  if (i === undefined) { error("grain_scope: unknown lane " + lane + "\n"); return; }
  bases[i] = v;
}

// grain <time> <pitch st> <dur ms> <shape> <amp> <pan> <reverse>
function grain(time, pitch, dur, shape, amp, pan, rev) {
  grains.push({ t: Date.now(), v: [time, pitch, dur, shape, amp, pan], rev: rev ? 1 : 0 });
  if (grains.length > MAX_GRAINS) grains.shift();
}

var tick_task = new Task(function () {
  var cutoff = Date.now() - window_s * 1000;
  while (grains.length && grains[0].t < cutoff) grains.shift();
  mgraphics.redraw();
}, this);
tick_task.interval = 33;
tick_task.repeat();

function norm(lane, v) {
  // 0..1 position along the lane axis, clamped
  var a = lane.lo, b = lane.hi, x;
  if (lane.log) { x = (Math.log(Math.max(v, a)) - Math.log(a)) / (Math.log(b) - Math.log(a)); }
  else { x = (v - a) / (b - a); }
  return Math.max(0, Math.min(1, x));
}

function fmt(lane, v) { return v.toFixed(lane.fmt) + (lane.unit || ""); }

function paint() {
  var w = box.rect[2] - box.rect[0], h = box.rect[3] - box.rect[1];
  var labW = 44, valW = 70, padT = 4, padB = 4;
  var px0 = labW, px1 = w - valW;
  var laneH = (h - padT - padB) / LANES.length;
  var now = Date.now(), span = window_s * 1000;
  var X = function (t) { return px0 + (1 - (now - t) / span) * (px1 - px0); };

  with (mgraphics) {
    set_source_rgba(0.11, 0.11, 0.11, 1); rectangle(0, 0, w, h); fill();
    select_font_face("Arial"); set_font_size(10);

    for (var li = 0; li < LANES.length; li++) {
      var L = LANES[li];
      var y0 = padT + li * laneH, y1 = y0 + laneH - 3;
      var Y = function (v) { return y1 - norm(L, v) * (y1 - y0); };

      // lane background
      set_source_rgba(0.16, 0.16, 0.16, 1); rectangle(px0, y0, px1 - px0, y1 - y0); fill();

      // label
      set_source_rgba(0.75, 0.75, 0.75, 1);
      move_to(4, y0 + 12); show_text(L.label);

      // window stats
      var n = 0, mn = 1e9, mx = -1e9, sum = 0;
      for (var gi = 0; gi < grains.length; gi++) {
        var v = grains[gi].v[li];
        n++; sum += v; if (v < mn) mn = v; if (v > mx) mx = v;
      }

      // min..max strip
      if (n > 1) {
        set_source_rgba(0.95, 0.65, 0.30, 0.18);
        rectangle(px0, Y(mx), px1 - px0, Math.max(1, Y(mn) - Y(mx))); fill();
      }

      // base line (dashed)
      if (bases[li] !== null) {
        set_source_rgba(1, 1, 1, 0.8); set_line_width(1);
        var by = Y(bases[li]);
        for (var dx = px0; dx < px1; dx += 8) { move_to(dx, by); line_to(Math.min(dx + 4, px1), by); stroke(); }
      }

      // grains
      for (var gj = 0; gj < grains.length; gj++) {
        var g = grains[gj];
        var gx = X(g.t), gy = Y(g.v[li]);
        var a = Math.max(0.25, Math.min(1, g.v[4]));
        if (g.rev) {
          set_source_rgba(0.35, 0.65, 0.95, a); set_line_width(1.2);
          ellipse(gx - 3, gy - 3, 6, 6); stroke();
        } else {
          set_source_rgba(1, 1, 1, a);
          ellipse(gx - 2.5, gy - 2.5, 5, 5); fill();
        }
      }

      // readout: mean and spread
      set_source_rgba(0.75, 0.75, 0.75, 1);
      if (n) {
        move_to(px1 + 6, y0 + 12); show_text(fmt(L, sum / n));
        set_source_rgba(0.55, 0.55, 0.55, 1);
        move_to(px1 + 6, y0 + 24); show_text("±" + fmt(L, (mx - mn) / 2));
      }
    }
  }
}
