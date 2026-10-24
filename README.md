# portieres~ 

Max 9 external port of the Mutable Instruments **Beads** granular processor. DSP is Emilie Gillet's code
(MIT) plus stmlib, with one small observer hook that reports grain starts (no audio change); `source/ext/` adds a host-rate wrapper.

## Help
See Max Helper object

## Outlets
`portieres~` has nine outlets: **L**, **R / gate**, **grain trigger** (signal), **grain messages**, **LFO values** (messages) and four
**LFO signals** (see below).
- *Grain trigger*: a 1-sample impulse (1.0) each time a grain starts. It is quantised to one codec block (about 0.25 ms) and
  lines up with the audio output; the impulse marks the trigger, and the audible grain follows 0 to 3 ms later depending on the media.
- *Grain messages* (fourth outlet): one `grain` message per grain, sent from the scheduler thread (so it is not sample accurate):
  `grain <time> <pitch st> <dur ms> <shape> <amp> <pan> <reverse>`
  where time is the read position 0..1, pitch is in semitones (always the magnitude, see reverse), shape 0..1, pan 0..1 (0.5 centre) and reverse is 0/1.
- Only granular mode produces grains. In delay mode (size > 0.99) and in the density dead zone there are none.
- Grains are generated while the **seed** gate is held, the seed button is on or locked (`seed 2`), or a seed signal is patched; with no seed there are no triggers.

## LFOs, stereo split and spread (port addition)
Four LFOs run inside the external (the device uses two) and are **sampled once per grain**, so grains born at the same moment can
see different LFO values (like the attenuverters' random spread, but shaped by an LFO). They follow Ableton's Live 12 LFO device:
shape, wave shape, steps, jitter, smooth, hold, depth and offset, a Free (Hz, x10) or Sync (note value) rate, all in 0..1.
- `lfo <1-4> <param> [value]` with `param` one of
  - `shape` 0 sine (starts at the top), 1 up, 2 down, 3 triangle, 4 square (low first), 5 random (new value each cycle), 6 bin (random 0/1),
    7 stray (two noise bursts under a Blackman window), 8 glider (glides between random values);
  - `wave` -100..100, the wave-shape curve: it bends the phase (an exponent up to 1/0.05, mirrored for negative values) before the waveform
    is drawn, so a square gets a pulse width; sine, up, down, triangle and square only;
  - `steps` 0 = off, 1..24 levels (not for square, random and bin);
  - `jitter` 0..100, a random wobble at 10 Hz added to the wave (up to +/-0.67); `smooth` 0..100, a slew of 0..200 ms (applies to jitter too);
  - `hold` 0/1, freeze the output while 1 (the value held is the smoothed one, before depth and offset);
  - `depth` 0..100 and `offset` -100..100: the output is `0.5 + offset/200 + depth/100 * (value - 0.5)`, clipped to 0..1;
  - `rate` (Hz, 0..40), `x10` (0/1, multiplies the rate), `sync` (0/1) and `div` (0-23, the sync rate as note values:
    1/64 1/48 1/32 1/24 1/16 1/12 1/8 1/6 3/16 1/4 5/16 1/3 3/8 1/2 3/4 1 1.5 2 3 4 6 8 16 32; 1/4 = one beat, 1 = a whole note);
  - `split` (degrees, the stereo split, see below) and `reset` (restarts the cycle).
  `uni <0|1>` is the old per-LFO polarity switch; it now just sets the polarity of every cell of that LFO.
- **LFO signals**: outlets 6 to 9 carry the LFOs as signals, 0..1: LFO 1 at the left edge of the stereo field, LFO 1 right edge, LFO 2 left, LFO 2
  right (the same two values the grains see at the extremes of the field; they are the same signal when `split` is 0). The device feeds them to
  `live.scope~` for the scrolling preview. They are held per codec block (about 0.25 ms) and lined up with the audio output.
- `amt <dest> <1-4> <percent>` is the modulation matrix: `dest` is `time`, `size`, `shape`, `pitch`, `density`, `feedback`,
  `reverb` or `drywet`. **100% means the LFO travels the knob's whole range** (amount x the range, clipped at its ends). The LFO is
  0..1 and each cell applies it either bipolar or unipolar (see `pol`):
  bipolar (+/-, the default) swings around the knob, so with the knob in the middle +100% runs from the bottom to the top of the range
  (peak to peak = the whole range) and +50% from a quarter to three quarters; unipolar (+) only goes up from the knob, by up to
  amount x the range, and comes back to it. A negative amount flips the direction. Off-centre knobs clip at the ends. Pitch's range
  is -24..+24 st (48), so bipolar +100% there is +/-24 st.
- `pol <dest> <1-4> <0|1>` sets the polarity of one matrix cell: 1 = bipolar +/- (the default), 0 = unipolar +. The device has a +/-
  button beside every amount. The LFOs themselves are always 0..1 (that is also what `poll` reports and the display draws); the
  cell turns that into a swing around the knob (lfo - 0.5) or an upward move from it (lfo).
- **Stereo split**: each LFO's `split` is how far apart (in degrees of its cycle) the left and right edges of the stereo field sample it.
  A grain panned hard left sees the LFO `split/2` earlier, hard right `split/2` later. With `split 0` all grains see the same value.
  Time, pitch and shape are sampled per grain; size is drawn before the grain's pan exists, so it (and the block-rate
  destinations density, feedback, reverb and dry/wet) follow the centre value.
- **Phase alone creates the stereo split.** An LFO that feeds time, shape or pitch and has a `split` spreads the grains across the
  stereo field by itself (full width at 180 degrees, half at 90), and each grain's position in the field decides which LFO phase
  it samples: the grain at the far left always sees `-split/2`, the far right `+split/2`. With `split 0` an LFO never moves the pan.
- **Dry/Wet position** (`drywetpost`, attribute, 0 or 1): where the Dry/Wet balance sits relative to the dirty-tape wobble, the
  pre-reverb limiter and the reverb. 0 (the original) mixes dry and wet first, so wobble and reverb act on the mix, dry included. 1
  mixes after them: only the wet signal is wobbled and reverberated, the dry stays exactly as it came in (and with Dry/Wet fully dry
  there is no reverb tail at all). The dry is also the clean input: it skips the medium's bit-crushing (8-bit mu-law on dirty tape,
  12-bit on vintage digital) and the input soft clip. The Dry/Wet curve, Level Cap and everything before the mix are unchanged.
- **Spread in delay mode** (Size past 0.99, where there are taps instead of grains): `spread` widens the stereo image of the taps by
  decorrelation. Taps have no pan to randomise, and at a steady Time setting only one tap sounds, so panning taps just parks the echo on
  one side. Instead the mid signal (L+R)/2 goes through two different chains of three allpass filters (3 to 8 ms, flat in level), one
  per channel, and Spread blends each channel from the plain signal (0, the original, byte for byte) to its own phase-scrambled copy
  (1). At 1 a mono echo comes out as two uncorrelated copies at the same level on both sides (correlation about 0), so nothing leans
  left or right and it does not change when the Time multiplier crosses a whole number. The side signal (L-R)/2 is kept, so a stereo
  source stays itself and gets extra width on top. The level is compensated; full Spread keeps each channel's level exactly. Only the
  Spread knob does this: the LFO Phase split has no effect on taps, because it works by reading the LFO per grain.
- **Seed step** (`seedstep`, 0-15, attribute) and `seedsync`: with the seed locked and a clock or trigger patched in (density left of
  centre divides the pulses), the divider fires on every Nth pulse (N = 1, 2, 3, 4, 6, 8, 12 or 16). `seedstep` chooses *which*
  pulse of each group of N fires: 0 is the first (the original behaviour), 1 the second, and so on; a step past N wraps round (step 6 on
  divide-by-4 = step 2). The count starts at the first pulse after a pause of 4 s or more. `seedsync [n]` sets the count of the *next* pulse
  (default 1: the pulse that has just gone by counts as the first of a group; `seedsync 0` makes the next pulse the first). The
  device sends a plain `seedsync` when Live's transport starts: the clock only switches to the transport-locked pulses a moment after
  play starts, so the downbeat pulse has already passed by then, and counting it as the first puts step 1 on the downbeat of every
  later bar for divisions of 1, 2, 4, 8 and 16 (with a 16th-note clock).
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
