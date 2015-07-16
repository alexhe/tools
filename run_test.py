#!/bin/bash

ROOT_DIR=$(pwd)
TMP_FILE=$ROOT_DIR"/tmp.txt"

function adb_root()
{
	dev_name=

	if [ -n "$1" ]; then
        	dev_name=$1
	fi

	if [ -n "$dev_name" ]; then
        	adb -s $dev_name root
	else
        	adb root
	fi
}

function get_data_free_size()
{
	dev_name=
	data_size=

        if [ -n "$1" ]; then
                dev_name=$1
        fi
	
	if [ -n "$dev_name" ]; then
                data_size=`adb -s $dev_name shell df |grep data |awk '{print $4}'`
        else
                data_size=`adb shell df |grep data  |awk '{print $4}'`
        fi
	# return is 25.4G,need cut down.
	# user (()) change str2int.
	return $((${data_size:0:2}))
}

function emmc_health_test()
{
	i=0
	dev_name=
	#16GB eMMC userdata free size 11G+ 
	#32GB eMMC userdata free size 25G+
	target_size=11

	if [ -n "$1" ]; then
		dev_name=$1
	fi

	if [ -n "$2" ]; then
                target_size=$2
		count=`expr $2 \* 1024`
        fi

	while ((i < 10000))
	do
		let ++i
		if [ -n "$dev_name" ]; then
			adb -s $dev_name shell dd if=/dev/zero of=/data/test bs=1m count=$count
			echo ""

			extcsd=`adb -s $dev_name shell cat /sys/kernel/debug/mmc0/mmc0:0001/ext_csd`
		else
			adb shell dd if=/dev/zero of=/data/test bs=1m count=count
			echo ""

			extcsd=`adb shell cat /sys/kernel/debug/mmc0/mmc0:0001/ext_csd`
		fi
		
        	size_w=`expr $i \* $target_size`
	        echo "Run times $i, have write size $size_w GB.\n"
        	echo "LIFE_A_SLC:"${extcsd:536:2}
        	echo ""
       		echo "LIFE_B_TLC:"${extcsd:538:2}

		#sleep 10s after write 100GB +  
		val=`expr $i % 100` 
        	if [ $val==0 ]
        	then
                	sleep 10
        	fi
	done
}

function args_write()
{
	echo $1":"$2 >$TMP_FILE
}

function args_get()
{
        awk -F ":" '{print $1 $2}' $ROOT_DIR"/tmp.txt"
}

for dev in `adb devices |grep -E "device\>" |awk '{print $1}'`
do
	get_data_free_size $dev
	size=$?
	args_write $dev $size

	args_get
done

