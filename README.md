# portieres~ 
<img width="100" height="200" alt="portieres" src="https://github.com/user-attachments/assets/1b0e6783-1ced-4277-9194-f0f68a690159" />

Max 9 external port of the Mutable Instruments **Beads** granular processor. DSP is Emilie Gillet's code
(MIT) plus stmlib, with one small observer hook that reports grain starts (no audio change); `source/ext/` adds a host-rate wrapper.

## Help
See Max Helper object

## Outlets
`portieres~` has four outlets: **L**, **R / gate**, **grain trigger** (signal) and **grain messages**.
- *Grain trigger*: a 1-sample impulse (1.0) each time a grain starts. It is quantised to one codec block (about 0.25 ms) and
  lines up with the audio output; the impulse marks the trigger, and the audible grain follows 0 to 3 ms later depending on the media.
- *Grain messages* (rightmost outlet): one `grain` message per grain, sent from the scheduler thread (so it is not sample accurate):
  `grain <time> <pitch st> <dur ms> <shape> <amp> <pan> <reverse>`
  where time is the read position 0..1, pitch is in semitones (always the magnitude, see reverse), shape 0..1, pan 0..1 (0.5 centre) and reverse is 0/1.
- Only granular mode produces grains. In delay mode (size > 0.99) and in the density dead zone there are none.
- Grains are generated while the **seed** gate is held, the seed button is on or locked (`seed 2`), or a seed signal is patched; with no seed there are no triggers.

## Notes / differences from hardware
- DSP runs at the media's codec rate (24/48/32/48 kHz) with a sinc resampler to/from the host rate.
- No AGC/calibration/normalization probing/synth mode/buffer backup; `gain` + per-media clipping replace gain_control.
- Seed input is not delayed by 2.5 ms; assignable CV and trim are not ported.
- Changing `media`/`mono` or restarting DSP clears the buffers.
- Random state is a global shared between instances.

## Install
Unzip, move the `portieres` folder into your Max 9 Packages folder, restart Max.
- macOS: `~/Documents/Max 9/Packages/`. If macOS blocks the external (it is ad-hoc signed, not notarized):
`xattr -dr com.apple.quarantine ~/Documents/Max\ 9/Packages/portieres`
- Windows: `Documents\Max 9\Packages\`. The package contains `portieres~.mxe64`.

## Building from Source
CI builds both platforms on every push (see `.github/workflows/build.yml`).
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

## Credits and license
DSP: Beads by Mutable Instruments, (c) Emilie Gillet, MIT. See `LICENSE-beads.txt`
and `LICENSE-stmlib`. Unofficial port, not affiliated with Mutable Instruments.
