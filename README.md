# portieres~ 

Max 9 external port of the Mutable Instruments **Beads** granular processor. DSP is Emilie Gillet's code
(MIT) plus stmlib, with one small observer hook that reports grain starts (no audio change); `source/ext/` adds a host-rate wrapper.

## Help
See Max Helper object

## Outlets
`portieres~` has five outlets: **L**, **R / gate**, **grain trigger** (signal), **grain messages** and **LFO values** (see below).
- *Grain trigger*: a 1-sample impulse (1.0) each time a grain starts. It is quantised to one codec block (about 0.25 ms) and
  lines up with the audio output; the impulse marks the trigger, and the audible grain follows 0 to 3 ms later depending on the media.
- *Grain messages* (rightmost outlet): one `grain` message per grain, sent from the scheduler thread (so it is not sample accurate):
  `grain <time> <pitch st> <dur ms> <shape> <amp> <pan> <reverse>`
  where time is the read position 0..1, pitch is in semitones (always the magnitude, see reverse), shape 0..1, pan 0..1 (0.5 centre) and reverse is 0/1.
- Only granular mode produces grains. In delay mode (size > 0.99) and in the density dead zone there are none.
- Grains are generated while the **seed** gate is held, the seed button is on or locked (`seed 2`), or a seed signal is patched; with no seed there are no triggers.

## LFOs, stereo split and spread (port addition)
Four LFOs run inside the external and are **sampled once per grain**, so grains born at the same moment can see different
LFO values (like the attenuverters' random spread, but shaped by an LFO).
- `lfo <1-4> <param> [value]` with `param` one of `shape` (0 sine, 1 triangle, 2 saw up, 3 saw down, 4 square, 5 random hold,
  6 random smooth), `rate` (Hz), `sync` (0/1), `div` (0-17: 1/16T 1/16 1/16. ... 2/1T 2/1 2/1., 7 = 1/4), `split` (degrees),
  `uni` (0/1) and `reset` (restarts the cycle).
- `amt <dest> <1-4> <percent>` is the modulation matrix: `dest` is `time`, `size`, `shape`, `pitch`, `density`, `feedback`,
  `reverb` or `drywet`. +100% from a bipolar LFO sweeps half the destination's range either side of its knob value (pitch: +/-24 st).
- **Stereo split**: each LFO's `split` is how far apart (in degrees of its cycle) the left and right edges of the stereo field sample it.
  A grain panned hard left sees the LFO `split/2` earlier, hard right `split/2` later. With `split 0` all grains see the same value.
  Time, pitch and shape are sampled per grain; size is drawn before the grain's pan exists, so it (and the block-rate
  destinations density, feedback, reverb and dry/wet) follow the centre value.
- **Phase alone creates the stereo split.** An LFO that feeds time, shape or pitch and has a `split` spreads the grains across the
  stereo field by itself (full width at 180 degrees, half at 90), and each grain's position in the field decides which LFO phase
  it samples: the grain at the far left always sees `-split/2`, the far right `+split/2`. With `split 0` an LFO never moves the pan.
- `spread` (attribute, 0-1) adds extra, independent random pan width on top: 0 is the original Beads behaviour (and draws no extra
  random numbers), 1 spreads grains from hard left to hard right. Note that Beads' own pan width grows with the number of
  overlapping grains, so modulating `size` or `density` changes it indirectly.
- `tempo` (attribute, BPM; 0 = follow the host tempo) drives synced LFOs.
- Send `poll` (about 30 times a second) to make the new fifth outlet report each LFO:
  `lfo <n> <value at left edge> <value at right edge> <centre phase 0-1>`. `poll` also refreshes the host tempo.

## Notes / differences from hardware
- DSP runs at the media's codec rate (24/48/32/48 kHz) with a sinc resampler to/from the host rate.
- No AGC/calibration/normalization probing/synth mode/buffer backup; `gain` + per-media clipping replace gain_control.
- Seed input is not delayed by 2.5 ms; assignable CV and trim are not ported.
- Changing `media`/`mono` or restarting DSP clears the buffers.
- Random state is a global shared between instances.

## Install
Download a zip from the releases tab.
Unzip, move the 'portieres' folder into your Max 9 Packages folder, restart Max.
- macOS: `~/Documents/Max 9/Packages/`. If macOS blocks the external:
  `xattr -dr com.apple.quarantine ~/Documents/Max\ 9/Packages/portieres`
- Windows: `Documents\Max 9\Packages\`. The package contains `portieres~.mxe64`.

## Building from Source
### Mac
Build: `source/build.sh` (clang only, no Xcode/CMake). Offline tests: `source/build_test.sh`
Restart Max after rebuilding (it won't reload a replaced .mxo)
### Windows
Requires Visual Studio 2022 with the C++ Clang tools (clang-cl) and CMake:
```
cmake -S source -B build -G "Visual Studio 17 2022" -A x64 -T ClangCL
cmake --build build --config Release
```
Output: `externals/portieres~.mxe64`. Restart Max after rebuilding.
### Linux
Not tested yet

## Credits and license
DSP: Original code by Emilie Gillet, MIT
Unofficial port, not affiliated with Mutable Instruments.
