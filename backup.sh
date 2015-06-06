adb shell dd if=/dev/block/platform/mtk-msdc.0/by-name/proinfo of=/sdcard/proinfo.bin
adb shell dd if=/dev/block/platform/mtk-msdc.0/by-name/nvram of=/sdcard/nvram.bin
adb shell sync
 
adb pull /sdcard/proinfo.bin ./proinfo.bin
adb pull /sdcard/nvram.bin ./nvram.bin
sync
