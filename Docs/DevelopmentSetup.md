# Setup Notes

## VSCode
Terminal Command: 
```bash
code
```

## Install Dependencies
```bash
sudo apt install qemu-user qemu-user-static binutils-aarch64-linux-gnu
```

## Locate Qt5
```bash
whereis qt5
find . -name qt5
sudo apt update
sudo apt install qtcreator qtbase5-dev qt5-qmake
```

## CMake Version
CMake is too old:
```bash
sudo apt install cmake
```

## Install g++
```bash
sudo apt install g++-12-aarch64-linux-gnu
```

## Sysroot Setup
```bash
cd /home/senprog/
cd Download
mv sysroot_Jun2024.tar.bz2 /home/senprog/sysroot1/.
```

### Extract Sysroot
```bash
tar -xvf sysroot_Jun2024.tar.bz2
find . -name qt*
cd uby22_sysroot1030/usr/lib/qt5/
sudo mv bin BAC_bin_BAC
sudo ln -s /usr/lib/qt5/bin
```

### Create Symlink
```bash
cd /usr/aarch64-linux-gnu/lib
sudo ln -s /home/senprog/sysroot1/uby22_sysroot1030/usr/lib/aarch64-linux-gnu/libfmt.so.9 libfmt.so.9
```

## Install Additional Packages
```bash
sudo apt install qemu-user
sudo apt install qtbase5-dev-tools
sudo apt install shutter
sudo apt install git
sudo apt install gitk
sudo apt install libgles-dev
sudo apt install pkg-config
```

## GitHub Setup
Go to GitHub settings/developer settings and create a personal access token.

## Clone Repository
```bash
git clone https://github.com/krontech/chronos5-control.git chronos5-control-sync-only
cd chronos5-control/
git checkout develop
```

### Update Submodules
```bash
git submodule update --init --recursive
```

## Build Control for Color Camera
Release Build:
```bash
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_MAKE_PROGRAM=/usr/bin/make -DCMAKE_C_COMPILER=/usr/bin/aarch64-linux-gnu-gcc-12 -DCMAKE_CXX_COMPILER=/usr/bin/aarch64-linux-gnu-g++-12 -G "Unix Makefiles" -DSENSOR_SELECTION=USE_GSPRINT_4510 -DTARGET_OS=TARGETOS_UB22 -DHAL_SELECTION=HAL_BETABOARD -DUBXILSYSROOT=/home/senprog/sysroot1/uby22_sysroot1030 -DSENSOR_FILTER=COLOR -DNO_SENSOR_ACTIVE=1 -S . -B build
```

### Binaries of Interest
- `build/src/control`
- `build/external/chronos5-control-comm/libcontrol_comm.so`

## Debug Build on Host
```bash
cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_MAKE_PROGRAM=/usr/bin/make -DCMAKE_C_COMPILER=/usr/bin/gcc-12 -DCMAKE_CXX_COMPILER=/usr/bin/g++-12 -G "Unix Makefiles" -DSENSOR_SELECTION=USE_GSPRINT_4510 -DTARGET_OS=TARGETOS_UB22 -DHAL_SELECTION=HAL_MOCK -DSENSOR_FILTER=COLOR -DDBGPRINTS=1 -DDEV_IO_LOG=1 -DUSE_KASSERT=1 -DNO_SENSOR_ACTIVE=1 -S . -B build
```

### Build Control with Debug Logging
```bash
cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_MAKE_PROGRAM=/usr/bin/make -DCMAKE_C_COMPILER=/usr/bin/aarch64-linux-gnu-gcc-12 -DCMAKE_CXX_COMPILER=/usr/bin/aarch64-linux-gnu-g++-12 -G "Unix Makefiles" -DSENSOR_SELECTION=USE_GSPRINT_4510 -DTARGET_OS=TARGETOS_UB22 -DHAL_SELECTION=HAL_BETABOARD -DUBXILSYSROOT=/home/senprog/sysroot1/uby22_sysroot1030 -DSENSOR_FILTER=COLOR -DDBGPRINTS=1 -DDEV_IO_LOG=1 -DLOG_TO_CONSOLE=1 -DUSE_KASSERT=1 -DNO_SENSOR_ACTIVE=1 -S . -B build
```

### Temperature Log Flag
```bash
LOG_TEMPERATURES_TO_CSV
```

### Build Command
```bash
cd build
cmake --build . --target control -- -j16
```

## New Merged Repository
Binaries of Interest:
- `build/src/control`
- `shaders in build/src/Video/Display/MALI/encrypted/`

## Build Video-Service Release
```bash
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_MAKE_PROGRAM=/usr/bin/make -DCMAKE_C_COMPILER=/usr/bin/aarch64-linux-gnu-gcc-12 -DCMAKE_CXX_COMPILER=/usr/bin/aarch64-linux-gnu-g++-12 -G "Unix Makefiles" -DUBXILSYSROOT=/home/senprog/sysroot1/uby22_sysroot1030 -DSENSOR_SELECTION=USE_GSPRINT_4510 -DSENSOR_FILTER=COLOR -S . -B build
```

### Build Video Target
```bash
cd build
cmake --build . --target video -- -j16
```

## Chronos5 GUI Setup
Clone Repository:
```bash
git clone https://github.com/krontech/chronos5-gui.git chronos5-gui-new
cd chronos5-gui-new
git checkout develop
git submodule update --init --recursive
```

### Build GUI Release
```bash
cd src
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_MAKE_PROGRAM=/usr/bin/make -DCMAKE_C_COMPILER=/usr/bin/aarch64-linux-gnu-gcc-12 -DCMAKE_CXX_COMPILER=/usr/bin/aarch64-linux-gnu-g++-12 -G "Unix Makefiles" -DUBXILSYSROOT=/home/senprog/sysroot1/uby22_sysroot1030 -DSENSOR_FILTER=COLOR -DTURNOFFLCD=TRUE -S . -B build
```

### Build Command
```bash
cd build
cmake --build . -- -j16
```

## Build Chronos5 Update GUI
```bash
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_MAKE_PROGRAM=/usr/bin/make -DCMAKE_C_COMPILER=/usr/bin/aarch64-linux-gnu-gcc-12 -DCMAKE_CXX_COMPILER=/usr/bin/aarch64-linux-gnu-g++-12 -G "Unix Makefiles" -DUBXILSYSROOT=/home/senprog/sysroot1/uby22_sysroot1030 -S . -B build
```

### Build Command
```bash
cd build
cmake --build . -- -j16
```

### Binaries of Interest
- `build/chronos5-update`

## Install Additional Dependencies
```bash
sudo apt install lcov
sudo apt update && sudo apt upgrade -y
sudo apt install cmake -y
cmake --version
sudo apt-get remove -y cmake
sudo apt install build-essential -y
sudo apt install checkinstall -y
sudo apt install zlib1g-dev -y
sudo apt install libssl-dev -y
```

### Install CMake from Source
```bash
wget https://github.com/Kitware/
tar -xzvf cmake-3.24.2.tar.gz
cd cmake-3.24.2/
./bootstrap
make
sudo make install
```

### Clear Command Cache
```bash
hash -r
```

### Sysroot Path
```
/home/senprog/sysroot1/uby22_sysroot1030
```

## Build Control by Running for Color Camera
```bash
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_MAKE_PROGRAM=/usr/bin/
cd build
cmake --build . --target control -- -j16
```

## Enable Ubuntu Pro
```bash
pro attach
```

## Remove Temporary Files
```bash
rm -rf cmake-3.29.7-linux-x86_64
```

## Install Additional Packages
```bash
sudo apt install build-essential -y
sudo apt install checkinstall -y
sudo apt install zlib1g-dev -y
sudo apt install libssl-dev -y
```

## Download and Install CMake
```bash
wget https://github.com/Kitware/
chmod 777 cmake-3.24.2.tar.gz 
tar -xzvf cmake-3.24.2.tar.gz
cd cmake-3.24.2/
./bootstrap 
make
sudo make install
```

## Check CMake Version
```bash
which cmake
hash -r
cmake --version
```

## Build Commands
```bash
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_MAKE_PROGRAM=/usr/bin/
sudo cp chronos5-gui /usr/bin
sudo cp chronos5-update /usr/bin
```

## Image Extraction and Disk Creation
```bash
unxz temp-1.6.0-color.img.xz
```

### Install GitHub Desktop
```bash
sudo apt update && sudo apt install github-desktop
sudo apt install curl
```

## Host Commands to Get/Set UI or Camera Parameters
```bash
curl -X POST -d '["currentIso"]' http://192.168.1.103:80/get
curl -X POST -d '[{"currentIso":400}]' http://192.168.1.103:80/set
curl -X POST -d '["currentIso"]' http://192.168.1.103:80/range
```

## Copy Local Build to Camera
```bash
sudo cp libcontrol_comm.so /usr/lib/aarch64-linux-gnu/
sudo cp libvideo_comm.so /usr/lib/aarch64-linux-gnu/
```

## On Camera
```bash
sudo cp control /usr/bin
sudo cp chronos5-gui /usr/bin
```

## Enable and Disable Service at Boot
```bash
# Enable
sudo systemctl enable pmicmodecheck

# Disable
sudo systemctl disable pmicmodecheck
```

## Required Packages for GUI
```bash
sudo apt install net-tools exfatprogs libqt5charts5-dev qtdeclarative5-dev qml-module-qtquick-dialogs qml-module-qtquick-controls qml-module-qtquick-controls2 qml-module-qtquick-shapes qml-module-qtquick-virtualkeyboard qml-module-qtcharts qml-module-qt-labs-settings qml-module-qt-labs-folderlistmodel qml-module-qtqml-models2 qtvirtualkeyboard-plugin
```

## Release Version Build
```bash
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_MAKE_PROGRAM=/usr/bin/make -DCMAKE_C_COMPILER=/usr/bin/aarch64-linux-gnu-gcc-12 -DCMAKE_CXX_COMPILER=/usr/bin/aarch64-linux-gnu-g++-12 -G "Unix Makefiles" -DSENSOR_SELECTION=USE_GSPRINT_4510 -DTARGET_OS=TARGETOS_UB22 -DHAL_SELECTION=HAL_BETABOARD -DUBXILSYSROOT=/home/senprog/sysroot1/uby22_sysroot1030 -DSENSOR_FILTER=COLOR -DNO_SENSOR_ACTIVE=1 -S . -B build

cd build
cmake --build . --target control -- -j16
```

## Flush a New Temp Image
```bash
unxz temp-1.6.0-color.img.xz
```

### Manual Control and GUI Start for Development
- Launch **Start Disk Creator** from the search bar.
- Choose the disk image to create a boot image on an SD card.
- Choose the image to burn on the SD card.
- Choose to make a boot disk to start creating the bootable SD card.

## After Flushing New Temp Image on Camera
- Boot up the camera.
- Disable the service:
```bash
sudo systemctl disable pmicmodecheck
```
- Reboot the camera:
```bash
sudo reboot
```

## Manual Run Camera
```bash
sudo ./control    # Enter password but wait for other GUI to run first
sudo ./chronos5-gui -platform chronos
```

## Load Modules at Boot
Replace **boot.bin** and **chronos.ko** in the camera:
```bash
./usr/lib/modules/5.15.0-1030-xilinx-zynqmp/kernel/chronos/chronos.ko
/boot/firmware/boot.bin
```
