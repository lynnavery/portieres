# Windows build of portieres~ (macOS uses build.sh). Produces ../externals/portieres~.mxe64
# Configure with clang-cl: cmake -S source -B build -G "Visual Studio 17 2022" -A x64 -T ClangCL
cmake_minimum_required(VERSION 3.20)
project(portieres CXX)

if(NOT WIN32)
  message(FATAL_ERROR "This CMakeLists is Windows-only; on macOS run source/build.sh")
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
# static CRT so users don't need the VC++ redistributable
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded")

set(C74 ${CMAKE_CURRENT_SOURCE_DIR}/max-sdk-base/c74support)

add_library(portieres MODULE
  ext/beads_tilde.cpp
  ext/engine.cc
  beads/dsp/processor.cc
  beads/dsp/trigger_generator.cc
  beads/dsp/delay_controller.cc
  beads/dsp/delay_clock.cc
  beads/dsp/mu_law.cc
  beads/resources.cc
  stmlib/dsp/units.cc
  stmlib/utils/random.cc
  stmlib/dsp/atan.cc)

set_target_properties(portieres PROPERTIES
  OUTPUT_NAME "portieres~"
  PREFIX ""
  SUFFIX ".mxe64"
  LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../externals
  RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../externals)
# multi-config generators (Visual Studio) append the config name unless overridden
foreach(cfg RELEASE DEBUG RELWITHDEBINFO MINSIZEREL)
  set_target_properties(portieres PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY_${cfg} ${CMAKE_CURRENT_SOURCE_DIR}/../externals
    RUNTIME_OUTPUT_DIRECTORY_${cfg} ${CMAKE_CURRENT_SOURCE_DIR}/../externals)
endforeach()

target_include_directories(portieres PRIVATE
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${C74}/max-includes ${C74}/msp-includes)

target_compile_definitions(portieres PRIVATE
  TEST WIN_VERSION WIN_EXT_VERSION _CRT_SECURE_NO_WARNINGS _USE_MATH_DEFINES NOMINMAX)

# upstream stmlib uses __attribute__((always_inline/packed)), so build with clang-cl
target_compile_options(portieres PRIVATE -ffast-math -fno-strict-aliasing -w)

target_link_libraries(portieres PRIVATE
  ${C74}/max-includes/x64/MaxAPI.lib
  ${C74}/msp-includes/x64/MaxAudio.lib)
