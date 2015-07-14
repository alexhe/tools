#!/bin/bash
adb -s A10ABL24QYQV root
sleep 5
#adb -s A10ABL24QYQV remount
#sleep 5

#adb -s A10ABL24QYQV push iozone64 /system/bin
#adb -s A10ABL24QYQV shell chmod 777 /system/bin/iozone64

#excel_name="/data/Iozone"

declare -i i=0
while ((i < 10000))
do
	#echo $i
	let ++i
	#writename=$excel_name$i".xls"
	#adb -s A10ABL24QYQV shell iozone64 -I -s 11g -i0  -f /data/iozonetest -Rb $writename
	adb -s A10ABL24QYQV shell dd if=/dev/zero of=/data/test bs=1m count=11264
        adb -s A10ABL24QYQV shell df |grep data
	
	extcsd=`adb -s A10ABL24QYQV shell cat /sys/kernel/debug/mmc0/mmc0:0001/ext_csd`

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
