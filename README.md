# portieres~ 
<img width="100" height="200" alt="portieres" src="https://github.com/user-attachments/assets/1b0e6783-1ced-4277-9194-f0f68a690159" />

Max 9 external port of the Mutable Instruments **Beads** granular processor. DSP is the unmodified code
(MIT, Emilie Gillet) plus stmlib; `source/ext/` adds a host-rate wrapper.

## Help
See Max Helper object

## Notes / differences from hardware
- DSP runs at the media's codec rate (24/48/32/48 kHz) with a sinc resampler to/from the host rate.
- No AGC/calibration/normalization probing/synth mode/buffer backup; `gain` + per-media clipping replace gain_control.
- Seed input is not delayed by 2.5 ms; assignable CV and trim are not ported.
- Changing `media`/`mono` or restarting DSP clears the buffers.
- Random state is a global shared between instances.

## Install
Unzip, move the `portieres` folder into `~/Documents/Max 9/Packages/`, restart Max.
If macOS blocks the external (it is ad-hoc signed, not notarized):
`xattr -dr com.apple.quarantine ~/Documents/Max\ 9/Packages/portieres`
## Building from Source
### Mac
Build: `source/build.sh` (clang only, no Xcode/CMake). Offline tests: `source/build_test.sh`
Restart Max after rebuilding (it won't reload a replaced .mxo)
## Credits and license
DSP: Beads by Mutable Instruments, (c) Emilie Gillet, MIT. See `LICENSE-beads.txt`
and `LICENSE-stmlib`. Unofficial port, not affiliated with Mutable Instruments.
