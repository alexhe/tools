#!/usr/bin/sh

export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=arm-eabi-

cd ../msm/

make shamu_defconfig
make -j8

export TARGET_PREBUILT_KERNEL=../msm/arch/arm/boot/zImage-dtb
cd ../nexus_android-5.1.1_r4/

make -j8 bootimage
