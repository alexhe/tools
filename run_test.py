#!/bin/bash

dev_name="123456789ABC"

if [ -n "$dev_name" ]; then
	adb -s $dev_name root
else
	adb root
fi

sleep 5

declare -i i=0

while ((i < 10000))
do
	let ++i
	if [ -n "$dev_name" ]; then
		adb -s $dev_name shell dd if=/dev/zero of=/data/test bs=1m count=112
		adb -s $dev_name shell df |grep data

		extcsd=`adb -s A10ABL24QYQV shell cat /sys/kernel/debug/mmc0/mmc0:0001/ext_csd`
	else
		adb shell dd if=/dev/zero of=/data/test bs=1m count=11264
		echo ""
		adb shell df |grep data

		extcsd=`adb shell cat /sys/kernel/debug/mmc0/mmc0:0001/ext_csd`
	fi

        size_w=`expr $i \* 11`
        echo "Run times $i, have write size $size_w GB.\n"
        echo "LIFE_A_SLC:"${extcsd:536:2}
        echo ""
        echo "LIFE_B_TLC:"${extcsd:538:2}

	val=`expr $i % 10`
        if [ $val==0 ]
        then
                sleep 10
        fi
done
