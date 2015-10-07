#!/bin/sh

DEVICES_LIST=`adb devices | awk '{print $1}'`

function dev_reboot {
        echo "$1 Rebooting ..."
        adb -s $1 shell reboot
}

function mute {
	echo "$1 Mute ..."
	adb -s $1 shell 'am startservice com.jacky.permanent/com.jacky.permanent.MyService;export CLASSPATH=/sdcard/AutoTest/test.jar;nohup app_process /sdcard/AutoTest svpn.udp.test.Test &'
}

function install {
	#echo "$1 Mute ..."
	adb -s $1 install mute.apk
	#sleep 10 
	#adb -s $1 shell "am startservice com.jacky.permanent/com.jacky.permanent.MyService;export CLASSPATH=/sdcard/AutoTest/test.jar;nohup app_process /sdcard/AutoTest svpn.udp.test.Test &" 
}

function monkey {
	 #mute $1
         echo "$1 Start Run ----- MONKEY TEST -----" 
         adb -s $1 push ./blacklist.txt  /sdcard/
         sleep 2
         adb -s $1 shell 'monkey -s 1000 --pkg-blacklist-file /sdcard/blacklist.txt --ignore-crashes --ignore-timeouts --kill-process-after-error --ignore-security-exceptions --pct-trackball 0 --pct-nav 0 -v -v -v --throttle 500 1200000000 > /sdcard/daily0115_1.log 2>&1 &'
         echo
}

function check {
        pid=`adb -s $1 shell ps |grep monkey`
	echo "[$1] $pid"
	echo 
}

if [ -n $1 ];then
	for dev in $DEVICES_LIST
	do
		if [ "$dev" != "List" ]; then
			if [ "$1" = "reboot" ]; then
                        	dev_reboot $dev 
			fi
			if [ "$1" = "mute" ];then
				mute $dev
			fi
			if [ "$1" = "install" ];then
                                install $dev
                        fi
			if [ "$1" = "test" ];then
                                monkey $dev
                        fi			
			if [ "$1" = "check" ];then
                                check $dev
                        fi

		fi
	done

	exit 0
fi

echo "Start Monkey Finish.... OK!"
