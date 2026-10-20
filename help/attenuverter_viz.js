// attenuverter_viz.js -- v8ui script for portieres~
//
// Shows one modulated parameter as a horizontal lane:
//   - base marker        what the knob is set to
//   - shaded band        where the attenuverter lets the value wander
//   - dots               the last grains actually played (fade out)
//
// Messages:
//   base <v>      knob value, in the parameter's own units
//   amt <v>       attenuverter, -1..1
//   cvmode <0|1>  1 if the CV inlet is connected (band = base .. base+amt*cvmax)
//                 0 for internal random (band = base +/- |amt|*range)
//   cvmax <v>     largest CV you expect to send, in parameter units
//   range <v>     lane half-range (24 for pitch)
//   grain t pitch dur shape amp pan rev   (straight from portieres~ outlet 3)
//   clear

mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;
inlets = 1;
outlets = 0;

var base_ = 0, amt_ = 0, cvmode_ = 0, cvmax_ = 12, range_ = 24;
var dots = [];            // {v, t, a}
var MAX_DOTS = 160, LIFE_MS = 2500;

function base(v) { base_ = v; mgraphics.redraw(); }
function amt(v) { amt_ = Math.max(-1, Math.min(1, v)); mgraphics.redraw(); }
function cvmode(v) { cvmode_ = v ? 1 : 0; mgraphics.redraw(); }
function cvmax(v) { cvmax_ = v; mgraphics.redraw(); }
function range(v) { range_ = Math.max(1e-6, v); mgraphics.redraw(); }
function clear() { dots = []; mgraphics.redraw(); }

// grain <time> <pitch st> <dur ms> <shape> <amp> <pan> <reverse>
function grain(t, pitch, dur, shape, amp, pan, rev) {
  dots.push({ v: pitch, t: Date.now(), a: Math.max(0.2, Math.min(1, amp)) });
  if (dots.length > MAX_DOTS) dots.shift();
}

var tick_task = new Task(function () {
  var now = Date.now();
  while (dots.length && now - dots[0].t > LIFE_MS) dots.shift();
  mgraphics.redraw();
}, this);
tick_task.interval = 40;
tick_task.repeat();

function band() {
  // returns [lo, hi] in parameter units
  if (cvmode_) {
    var a = base_, b = base_ + amt_ * cvmax_;
    return [Math.min(a, b), Math.max(a, b)];
  }
  var w = Math.abs(amt_) * range_;
  return [base_ - w, base_ + w];
}

function paint() {
  var w = box.rect[2] - box.rect[0], h = box.rect[3] - box.rect[1];
  var pad = 10, x0 = pad, x1 = w - pad;
  var X = function (v) {
    var c = Math.max(-range_, Math.min(range_, v));
    return x0 + (c + range_) / (2 * range_) * (x1 - x0);
  };
  var mid = h * 0.55;

  with (mgraphics) {
    set_source_rgba(0.11, 0.11, 0.11, 1); rectangle(0, 0, w, h); fill();

    // axis + ticks
    set_source_rgba(0.45, 0.45, 0.45, 1); set_line_width(1);
    move_to(x0, mid); line_to(x1, mid); stroke();
    var step = range_ > 12 ? 12 : range_ / 2;
    for (var t = -range_; t <= range_ + 1e-6; t += step) {
      move_to(X(t), mid - 4); line_to(X(t), mid + 4); stroke();
    }
    move_to(X(0), mid - 9); line_to(X(0), mid + 9); stroke();

    // attenuverter band
    var bd = band();
    var col = cvmode_ ? [0.35, 0.65, 0.95] : [0.95, 0.65, 0.30];
    set_source_rgba(col[0], col[1], col[2], 0.28);
    rectangle(X(bd[0]), mid - 14, Math.max(2, X(bd[1]) - X(bd[0])), 28); fill();
    set_source_rgba(col[0], col[1], col[2], 0.9);
    move_to(X(bd[0]), mid - 14); line_to(X(bd[0]), mid + 14); stroke();
    move_to(X(bd[1]), mid - 14); line_to(X(bd[1]), mid + 14); stroke();

    // grain dots (fade with age, vertical jitter by amp so overlaps show)
    var now = Date.now();
    for (var i = 0; i < dots.length; i++) {
      var d = dots[i], age = (now - d.t) / LIFE_MS;
      set_source_rgba(1, 1, 1, Math.max(0, (1 - age) * d.a));
      var y = mid + ((i * 37) % 21) - 10;
      ellipse(X(d.v) - 2.5, y - 2.5, 5, 5); fill();
    }

    // base marker
    set_source_rgba(1, 1, 1, 1);
    move_to(X(base_), mid - 18); line_to(X(base_) - 5, mid - 26);
    line_to(X(base_) + 5, mid - 26); close_path(); fill();

    // label
    set_source_rgba(0.75, 0.75, 0.75, 1);
    select_font_face("Arial"); set_font_size(10);
    move_to(pad, 12);
    show_text((cvmode_ ? "CV mode: base .. base + amt*cv" : "random mode: base +/- |amt|*range")
              + "    amt " + amt_.toFixed(2));
  }
}
