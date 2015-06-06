adb push ./proinfo.bin /sdcard/proinfo.bin
adb push ./nvram.bin /sdcard/nvram.bin
adb shell sync
adb shell dd if=/sdcard/proinfo.bin of=/dev/block/platform/mtk-msdc.0/by-name/proinfo
adb shell dd if=/sdcard/nvram.bin of=/dev/block/platform/mtk-msdc.0/by-name/nvram
adb shell sync
