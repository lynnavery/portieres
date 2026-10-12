#!/bin/sh
# Builds ../externals/portieres~.mxo (arm64 + x86_64) without Xcode/CMake.
set -e
cd "$(dirname "$0")"
SDK="$(xcrun --show-sdk-path)"
OUT=../externals/portieres~.mxo
MAXINC=max-sdk-base/c74support
SRCS="ext/engine.cc beads/dsp/processor.cc beads/dsp/trigger_generator.cc beads/dsp/delay_controller.cc beads/dsp/delay_clock.cc beads/dsp/mu_law.cc beads/resources.cc stmlib/dsp/units.cc stmlib/utils/random.cc stmlib/dsp/atan.cc"
rm -rf "$OUT"; mkdir -p "$OUT/Contents/MacOS" /tmp/portieres_obj
ARCHS="${ARCHS:-arm64 x86_64}"
LIPO=""
for A in $ARCHS; do
  OBJS=""
  for F in $SRCS ext/beads_tilde.cpp; do
    O=/tmp/portieres_obj/$A-$(echo $F | tr '/' '_').o
    clang++ -arch $A -isysroot "$SDK" -nostdinc++ -isystem "$SDK/usr/include/c++/v1" \
      -std=c++17 -O3 -ffast-math -fno-strict-aliasing -DTEST -DMAC_VERSION -DMAXAPI_USE_MSCRT=0 \
      -mmacosx-version-min=11.0 -fvisibility=hidden -I. \
      -I$MAXINC/max-includes -I$MAXINC/msp-includes -I$MAXINC/jit-includes \
      -w -c $F -o $O &
    OBJS="$OBJS $O"
  done
  wait
  clang++ -arch $A -isysroot "$SDK" -nostdlib++ -bundle -undefined dynamic_lookup \
    -mmacosx-version-min=11.0 -L"$SDK/usr/lib" -lc++ \
    \
    $OBJS -o /tmp/portieres_obj/portieres~.$A
  LIPO="$LIPO /tmp/portieres_obj/portieres~.$A"
done
lipo -create $LIPO -output "$OUT/Contents/MacOS/portieres"
printf 'iLaXmax2' > "$OUT/Contents/PkgInfo"
cat > "$OUT/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleDevelopmentRegion</key><string>English</string>
<key>CFBundleExecutable</key><string>portieres</string>
<key>CFBundleIdentifier</key><string>com.lynn.portieres-tilde</string>
<key>CFBundleInfoDictionaryVersion</key><string>6.0</string>
<key>CFBundlePackageType</key><string>iLaX</string>
<key>CFBundleSignature</key><string>max2</string>
<key>CFBundleShortVersionString</key><string>0.1.0</string>
<key>CFBundleVersion</key><string>0.1.0</string>
<key>CFBundleName</key><string>portieres~</string>
<key>CSResourcesFileMapped</key><true/>
</dict></plist>
PLIST
codesign --force -s - "$OUT"
echo "built $OUT"; lipo -info "$OUT/Contents/MacOS/portieres"
