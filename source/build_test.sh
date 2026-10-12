#!/bin/sh
# Builds and runs the offline DSP smoke test (no Max required).
set -e
cd "$(dirname "$0")"
SRCS="beads/dsp/processor.cc beads/dsp/trigger_generator.cc beads/dsp/delay_controller.cc beads/dsp/delay_clock.cc beads/dsp/mu_law.cc beads/resources.cc stmlib/dsp/units.cc stmlib/utils/random.cc stmlib/dsp/atan.cc"
SDK="$(xcrun --show-sdk-path)"
clang++ -isysroot "$SDK" -nostdinc++ -isystem "$SDK/usr/include/c++/v1" -std=c++17 -O2 -DTEST -I. -w harness/test_beads.cc $SRCS -o /tmp/beads_test_bin
/tmp/beads_test_bin
# Engine-level test (resampling at several host rates)
clang++ -isysroot "$SDK" -nostdinc++ -isystem "$SDK/usr/include/c++/v1" -std=c++17 -O2 -DTEST -I. -w harness/test_engine.cc ext/engine.cc $(echo $SRCS | tr ' ' '\n' | grep -v '^$' | tr '\n' ' ') -o /tmp/beads_engine_bin
/tmp/beads_engine_bin
