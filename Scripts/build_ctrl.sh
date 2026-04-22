#! /bin/bash

home/luke/.local/share/JetBrains/Toolbox/apps/clion/bin/cmake/linux/x64/bin/cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=/usr/bin/aarch64-linux-gnu-gcc-12 -DCMAKE_CXX_COMPILER=/usr/bin/aarch64-linux-gnu-g++-12 -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug -DSENSOR_SELECTION=USE_GSPRINT_4510 -DTARGET_OS=TARGETOS_UB22 -DHAL_SELECTION=HAL_BETABOARD -DUBXILSYSROOT=/home/luke/Tools/Toolchains/XCompSysRoot_Jan2026 -DSENSOR_FILTER=COLOR -DNO_SENSOR_ACTIVE=1 -DKRON_BUILD_TYPE=DEVELOPMENT -S /home/luke/CLionProjects/chronos5-control -B /home/luke/CLionProjects/chronos5-control/Build

/home/luke/.local/share/JetBrains/Toolbox/apps/clion/bin/cmake/linux/x64/bin/cmake --build /home/luke/CLionProjects/chronos5-control/Build --target control -- -j 10
