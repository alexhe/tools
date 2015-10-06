#!/bin/sh

CES_LIST=`adb devices | awk '{print $1}'`
IMAGE=$1

function dev_reboot {
        echo "$1 Rebooting ..."
        adb -s $1 shell reboot
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
		./m86.sh $IMAGE
        fi
done

echo "Done"
