#!/usr/bin/env python3
"""Summarises the CSVs written by source/sweep_levels.sh.  usage: summarize_sweep.py [dir]"""
import csv
import glob
import os
import sys
from collections import defaultdict

D = sys.argv[1] if len(sys.argv) > 1 else os.path.expanduser("~/Documents/portieres-level-sweep")
COLS = ["sweep", "media", "input", "level_db", "density", "size", "time", "shape", "pitch", "size_amt", "time_amt",
        "shape_amt", "pitch_amt", "feedback", "reverb", "dry_wet", "spread", "gain", "gain_db", "peak", "over09", "over10"]
NAMES = {0: "dirty tape", 1: "clean tape", 2: "vintage digital", 3: "digital"}


def rows(pattern):
    out = []
    for f in sorted(glob.glob(os.path.join(D, pattern))):
        for line in open(f):
            if line.startswith("#") or not line.strip():
                continue
            v = line.strip().split(",")
            if len(v) != len(COLS):
                continue
            r = dict(zip(COLS, v))
            for k in COLS:
                if k not in ("sweep", "input"):
                    r[k] = float(r[k])
            out.append(r)
    return out


def heat(rs, key="gain_db"):
    """density (rows, top = 1.0) x size (cols) map of gain in dB, one char per cell."""
    cell = {(round(r["density"], 2), round(r["size"], 2)): r[key] for r in rs}
    dens = sorted({k[0] for k in cell}, reverse=True)
    sizes = sorted({k[1] for k in cell})
    ramp = "  .:-=+*#%@"      # <-10 ... >+10
    lines = ["      size " + " ".join("%3.1f" % s if i % 2 == 0 else "   " for i, s in enumerate(sizes))]
    for d in dens:
        row = ""
        for s in sizes:
            g = cell.get((d, s))
            idx = 0 if g is None else max(0, min(len(ramp) - 1, int((g + 10) / 2.2)))
            row += "  " + ramp[idx] + " "
        lines.append("dens %.2f %s" % (d, row))
    lines.append("   ramp: ' '<-10 dB ... '+' about 0 dB ... '@' >= +10 dB")
    return "\n".join(lines)


def main():
    any_data = False
    for media in (3, 2, 1, 0):
        g = rows("grid_media%d.csv" % media)
        if not g:
            continue
        any_data = True
        print("=" * 78)
        print("MEDIA %d (%s): density x size grid, -20 dBFS input, wet only, %d runs" % (media, NAMES[media], len(g)))
        silent = [r for r in g if r["gain_db"] < -100]
        if len(silent) == len(g):
            print("  every run is silent (output below -100 dB): the wet path produces no sound at all for this media")
            continue
        for inp in ("tone", "noise", "stereo_noise"):
            rs = [r for r in g if r["input"] == inp]
            if not rs:
                continue            # (sweep still running, or this input not reached yet)
            gains = sorted(r["gain_db"] for r in rs)
            hot = [r for r in rs if r["gain_db"] > 6]
            worst = max(rs, key=lambda r: r["gain_db"])
            print("  %-12s median %+5.1f dB | max %+5.1f dB at density %.2f size %.2f | >+3 dB in %3d cells, >+6 dB in %3d, >+9 dB in %3d of %d | max peak %.2f"
                  % (inp, gains[len(gains) // 2], worst["gain_db"], worst["density"], worst["size"],
                     sum(r["gain_db"] > 3 for r in rs), len(hot), sum(r["gain_db"] > 9 for r in rs), len(rs),
                     max(r["peak"] for r in rs)))
        if media == 3:
            print("\n  gain map, tone input (rows density, columns size):")
            print(heat([r for r in g if r["input"] == "tone"]))
            print("\n  gain map, stereo noise input:")
            print(heat([r for r in g if r["input"] == "stereo_noise"]))

    c = rows("coarse_media*.csv")
    if c:
        any_data = True
        print("=" * 78)
        print("HOT INPUTS (-12 and -6 dBFS), coarse grid: is the output bounded by the limiter?")
        for media in (3, 2, 1):
            for lv in (-20.0, -12.0, -6.0):
                rs = [r for r in (rows("grid_media%d.csv" % media) if lv == -20.0 else c) if r["media"] == media and r["level_db"] == lv]
                if not rs:
                    continue
                print("  media %d  input %+5.0f dBFS: max gain %+5.1f dB | max peak %.2f | worst sample-fraction over 0.9: %.3f over 1.0: %.4f"
                      % (media, lv, max(r["gain_db"] for r in rs), max(r["peak"] for r in rs),
                         max(r["over09"] for r in rs), max(r["over10"] for r in rs)))

    k = rows("knobs_media*.csv")
    if k:
        any_data = True
        print("=" * 78)
        print("ONE KNOB AT A TIME (tone, -20 dBFS). Range of output gain over each knob, at density/size = 0.7/0.5 and 1.0/0.8")
        by = defaultdict(list)
        for r in k:
            anchor = "default" if (abs(r["density"] - 0.7) < 1e-6 and abs(r["size"] - 0.5) < 1e-6) else "dense_long"
            by[(int(r["media"]), r["sweep"], anchor)].append(r)
        for media in (3, 2, 1):
            print("  media %d (%s)" % (media, NAMES[media]))
            for knob in ("time", "shape", "pitch", "size_amt", "time_amt", "shape_amt", "pitch_amt", "feedback", "reverb", "dry_wet", "spread", "gain", "phase"):
                parts = []
                for anchor in ("default", "dense_long"):
                    rs = by.get((media, knob, anchor))
                    if not rs:
                        continue
                    lo = min(rs, key=lambda r: r["gain_db"]); hi = max(rs, key=lambda r: r["gain_db"])
                    parts.append("%-10s %+6.1f .. %+6.1f dB (peak<=%.2f)" % (anchor, lo["gain_db"], hi["gain_db"], max(r["peak"] for r in rs)))
                if parts:
                    print("    %-10s %s" % (knob, "  |  ".join(parts)))

    l = rows("limiter_media3.csv")
    if l:
        any_data = True
        print("=" * 78)
        print("LIMITER CHECK (density 1.0, size 0.8, 10 s, digital): gain should fall as the input gets hotter")
        for r in l:
            print("  %-12s %-12s in %+4.0f dBFS -> gain %+6.1f dB  peak %.2f  over0.9 %.4f  over1.0 %.4f"
                  % (r["sweep"], r["input"], r["level_db"], r["gain_db"], r["peak"], r["over09"], r["over10"]))
    if not any_data:
        print("no data in", D)


main()
