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
  and `reset` (restarts the cycle). `uni <0|1>` is the old per-LFO polarity switch; it now just sets the polarity of every cell of that LFO.
- `amt <dest> <1-4> <percent>` is the modulation matrix: `dest` is `time`, `size`, `shape`, `pitch`, `density`, `feedback`,
  `reverb` or `drywet`. **The knob is the centre of the swing and the amount is how far the LFO travels, in knob turns**: the LFO
  (bipolar, -1..1) moves the value by amount x the knob's whole range, up and down around the knob, and the result is clipped
  at the ends of the range. So +100% swings +/-1 full turn (2 turns peak to peak), +50% swings +/-half a turn, and a negative
  amount flips the LFO upside down. Pitch's range is -24..+24 st (48), so +100% there is +/-48 st before clipping.
- `pol <dest> <1-4> <0|1>` sets the polarity of one matrix cell: 1 = bipolar +/- (the default, as above), 0 = unipolar +, where the LFO
  runs 0..1 so the value only moves up from the knob (down for a negative amount). The device has a +/- button beside every amount.
  The LFO values reported by `poll` (and its display) are always the bipolar -1..1 wave.
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
- Widening the stereo field (Spread, or Phase) does not make the output louder: Beads' pan law folds the other input channel into
  the side a grain is panned towards, which adds coherently for centred or mono-ish material and used to raise each channel
  by roughly 1-2.5 dB. Grain amplitude is scaled back by the amount of extra width Spread adds (none at Spread 0, and little when
  dense settings already pan wide). Note that the level still depends strongly on density and grain size - dense triggers with
  long grains can be about 10 dB hotter than the input, as in the original Beads.
- `tempo` (attribute, BPM; 0 = follow the host tempo) drives synced LFOs.
- Send `poll` (about 30 times a second) to make the new fifth outlet report each LFO:
  `lfo <n> <value at left edge> <value at right edge> <centre phase 0-1> <speed in Hz>` (the speed is the Rate knob, or the
  tempo-derived rate when synced; the display uses it to show one second of waveform per frame). `poll` also refreshes the host tempo.

## Level control: wet-path cap and overlap scaling (port additions)
Overlapping grains of the same material add up: with long grains at either density extreme the wet path comes out 10-15 dB
hotter than the input (worst case measured: +15 dB at density 0, size 0.9; see `source/sweep_levels.sh`). The original firmware only
had two fixed 0.9 peak limiters (still present here) and relied on the hardware input AGC (`gain_control`, not ported) to hand
it a hot, normalised input, so nothing bounded the gain relative to the input. Two switchable controls address that:
- `wetcap` (0/1, **on by default**) with `wetcap_db` (0-24, default 3): holds the wet signal to at most that many dB above a slow
  estimate of the input level. It only acts when the grains run hot (it changes nothing at ordinary settings), and the input estimate
  has a long memory (about 10 s) and is held while `freeze` is on, so tails, feedback and frozen textures are not clamped just because
  the live input went quiet. With `wetcap 0` the signal path is exactly the original.
- `overlap` (0/1, **off by default**) with `overlap_amt` (0-1, default 1): stronger overlap scaling. Each grain is scaled by
  `1/sqrt(grains playing)` in the original; this raises the exponent towards `1/(grains playing)`, which holds back grains that add
  coherently. It changes the character at dense settings, which is why it is optional. `overlap_amt 0` is the original.

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
