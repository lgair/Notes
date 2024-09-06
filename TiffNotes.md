# Control Service Getting started:

**CMake command args:**
`-DCMAKE_BUILD_TYPE=Release -DCMAKE_MAKE_PROGRAM=/usr/bin/make -DCMAKE_C_COMPILER=/usr/bin/aarch64-linux-gnu-gcc-12 -DCMAKE_CXX_COMPILER=/usr/bin/aarch64-linux-gnu-g++-12 -G "Unix Makefiles" -DSENSOR_SELECTION=USE_GSPRINT_4510 -DTARGET_OS=TARGETOS_UB22 -DHAL_SELECTION=HAL_BETABOARD -DUBXILSYSROOT=/path/to/sysroot -DSENSOR_FILTER=COLOR -DNO_SENSOR_ACTIVE=1 -S . -B build`

If using CLion ignore the build type, make_program c/c++ compiler paths and
the -S and build directory names as they are handled by CLions GUI.

## Project Requirements:
- MONO/Colour 4k12 camera
- Sysroot from June 2024
- Control Service - dev branch
- GUI Service - dev branch

### Sysroot creation on the host:
Qt tools in the sysroot must point to host Qt tools:

```bash
cd /home/dino/uby22_sysroot/usr/lib/qt5
sudo mv bin BAC_bin_BAC
sudo ln -s /usr/lib/qt5/bin
```

Must be able to run `resw_constants_generator` and `guide_presets_generator` on the host via emulator:

```bash
cd /usr/aarch64-linux-gnu/lib
sudo ln -s /home/dino/uby22_sysroot/usr/lib/aarch64-linux-gnu/libfmt.so.9 libfmt.so.9
```

Install emulator (needed for cross-compiling the `control` service):

```bash
sudo apt install qemu-user
```

Install qt tools:

```bash
 sudo apt install qtbase5-dev-tools
```

Arm64 emulator is required to generate two headers files. Run:
`sudo apt install qemu-user qemu-user-static binutils-aarch64-linux-gnu`

## Build notes

As of 08-01-2024 Debug build is broken, but Release build should work fine.
run `git clean -xfdf` to clean all build files.
reset cache and reload cmake
Build the control target(?)
