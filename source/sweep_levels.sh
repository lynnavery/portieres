#!/bin/sh
# Builds the output-level sweep (same flags as the real external) and runs it in parallel.
#   sh source/sweep_levels.sh [outdir] [wetcap 0|1] [overlap 0|1]
#   default outdir: ~/Documents/portieres-level-sweep; wetcap defaults to 1, overlap to 0 (the engine defaults)
#   MEDIAS="3 1" limits the media types (default: 1 2 3, plus the dirty-tape grid)
# Writes one CSV per sweep/media into outdir. See harness/sweep_levels.cc for the columns.
set -e
cd "$(dirname "$0")"
OUT="${1:-$HOME/Documents/portieres-level-sweep}"
CAP="${2:-1}"
OVL="${3:-0}"
MEDIAS="${MEDIAS:-1 2 3}"
mkdir -p "$OUT"
SRCS="beads/dsp/processor.cc beads/dsp/trigger_generator.cc beads/dsp/delay_controller.cc beads/dsp/delay_clock.cc beads/dsp/mu_law.cc beads/resources.cc stmlib/dsp/units.cc stmlib/utils/random.cc stmlib/dsp/atan.cc"
SDK="$(xcrun --show-sdk-path)"
BIN="$OUT/sweep_levels_bin"
clang++ -isysroot "$SDK" -nostdinc++ -isystem "$SDK/usr/include/c++/v1" -std=c++17 -O3 -ffast-math -fno-strict-aliasing \
  -DTEST -I. -w harness/sweep_levels.cc ext/engine.cc $SRCS -o "$BIN"
for media in $MEDIAS; do
  "$BIN" grid "$media" "$CAP" "$OVL" > "$OUT/grid_media$media.csv" &
  "$BIN" coarse "$media" "$CAP" "$OVL" > "$OUT/coarse_media$media.csv" &
  "$BIN" knobs "$media" "$CAP" "$OVL" > "$OUT/knobs_media$media.csv" &
done
"$BIN" limiter 3 "$CAP" "$OVL" > "$OUT/limiter_media3.csv" &
case " $MEDIAS " in *" 0 "*) "$BIN" grid 0 "$CAP" "$OVL" > "$OUT/grid_media0.csv" & ;; esac
wait
echo "done: $OUT"
