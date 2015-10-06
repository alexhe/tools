#!/bin/sh

CES_LIST=`adb devices | awk '{print $1}'`
IMAGE=$1

function flash_all {
	fastboot flash bootloader $1/device/meizu/m86/bootloader/eng/bootloader
	fastboot flash ldfw $1/device/meizu/m86/bootloader/eng/ldfw
	fastboot flash dtb $1/out/target/product/m86/dtb
	fastboot flash bootimg $1/out/target/product/m86/boot.img
	fastboot flash system $1/out/target/product/m86/system.img
	fastboot -w
	fastboot oem poweroff
}

if [ -z $IMAGE ]; then
	echo "Please input IMAGE PATH."
else
	echo "IMAGE:$IMAGE"
fi

# main loop
for dev in $DEVICES_LIST
do
	if [ "$dev" != "List" ]; then
		echo "Rebooting ...."
		adb -s $dev shell reboot fb
		echo
		sleep 5
		flash_all $IMAGE
        fi
done

echo "Done"
