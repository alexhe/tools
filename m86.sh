fastboot flash bootloader $1/device/meizu/m86/bootloader/eng/bootloader
fastboot flash ldfw $1/device/meizu/m86/bootloader/eng/ldfw
fastboot flash dtb $1/out/target/product/m86/dtb
fastboot flash bootimg $1/out/target/product/m86/boot.img
fastboot flash system $1/out/target/product/m86/system.img
fastboot -w
fastboot oem poweroff
