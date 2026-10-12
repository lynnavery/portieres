# portieres~ (port of Beads)

Max 9 external port of the Mutable Instruments **Beads** granular processor
(pichenettes/eurorack commit d8f4739). DSP is the unmodified upstream code
(MIT, Emilie Gillet) plus stmlib; `source/ext/` adds a host-rate wrapper.

Build: `source/build.sh` (clang only, no Xcode/CMake). Offline tests: `source/build_test.sh`.
Restart Max after rebuilding (it won't reload a replaced .mxo).

## Inlets (all signal)
L, R (unpatched R = mono), time cv, size cv, shape cv, pitch cv (semitones),
density cv, seed gate, freeze gate. Outlets: L, R (R = gate with `@gateout 1`).

## Attributes
time size shape density (0-1), pitch (-24..24 st), time_amt size_amt shape_amt
pitch_amt (-1..1 attenuverters; with no CV patched they set randomness), feedback
drywet reverb (0-1), gain, media (0 dirty tape, 1 clean tape, 2 vintage digital,
3 digital), seed (0 off/1 on/2 locked), freeze, gateout, mono.
size > 0.99 = delay mode.
density: left of centre = random triggers, right = periodic; 0.48-0.52 is a dead zone with no grains (seed only). Default 0.7.

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

## Credits and license
DSP: Beads by Mutable Instruments, (c) Emilie Gillet, MIT. See `LICENSE-beads.txt`
and `LICENSE-stmlib`. Unofficial port, not affiliated with Mutable Instruments.
