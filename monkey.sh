#!/bin/sh

DEVICES_LIST=`adb devices | awk '{print $1}'`

function dev_reboot {
        echo "$1 Rebooting ..."
        adb -s $1 shell reboot
}

if [ "$1" = "reboot" ]; then
        for dev in $DEVICES_LIST
        do
                if [ "$dev" != "List" ]; then
                        dev_reboot $dev
                fi
        done
        sleep 120

fi

if [ "$2" = "skip" ]; then
	exit 1;
fi

for dev in $DEVICES_LIST
do
        if [ "$dev" != "List" ]; then
                echo "$dev Start Run ----- MONKEY TEST -----" 
                adb -s $dev push ./blacklist.txt  /sdcard/
		sleep 1
		adb -s $dev shell " monkey -s 1000 --pkg-blacklist-file /sdcard/blacklist.txt --ignore-crashes --ignore-timeouts --kill-process-after-error --ignore-security-exceptions --pct-trackball 0 --pct-nav 0 -v -v -v --throttle 500 1200000000 > /sdcard/daily0115_1.log 2>&1 &"
		sleep 2
		echo
        fi
done

echo "Start Monkey Finish.... OK!"
