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
# Same engine test under UBSan: arm64 returns 0 for integer divide by zero, x86_64 (Rosetta) traps with SIGFPE,
# so this is what catches that class of bug on an arm64 machine.
clang++ -isysroot "$SDK" -nostdinc++ -isystem "$SDK/usr/include/c++/v1" -std=c++17 -O1 -DTEST -I. -w -fsanitize=integer-divide-by-zero -fno-sanitize-recover=all harness/test_engine.cc ext/engine.cc $(echo $SRCS | tr ' ' '\n' | grep -v '^$' | tr '\n' ' ') -o /tmp/beads_engine_ubsan
/tmp/beads_engine_ubsan | tail -1
