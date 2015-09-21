#!/system/bin/sh
#
# record the temp for M86
#

# Path
online_cpu_path=/sys/devices/system/cpu/online

freq_little_path=/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
freq_big_path=/sys/devices/system/cpu/cpu4/cpufreq/scaling_cur_freq

load_little_path=/sys/bus/cpu/devices/cpu0/cpufreq/interactive/cpu_util
load_big_path=/sys/bus/cpu/devices/cpu4/cpufreq/interactive/cpu_util

power_gpu_path=/sys/bus/platform/devices/14ac0000.mali/power_state
freq_gpu_path=/sys/bus/platform/devices/14ac0000.mali/clock
load_gpu_path=/sys/bus/platform/devices/14ac0000.mali/utilization

sample_cycle=1
[ -n "$1" ] && sample_cycle=$1

sample_loop=9999999999
[ -n "$2" ] && sample_loop=$2

loop=1

while [ $loop -le $sample_loop ];
do
	freq_big=0
	load_big="OFF OFF OFF OFF"
	load_little=0
	load_gpu=0
	freq_gpu=0

	power_gpu=`cat $power_gpu_path`
	online_cpu=`cat $online_cpu_path`
	freq_little=`cat $freq_little_path`
	load_little=`cat $load_little_path`

	little_num=0
	for i in 0 1 2 3
	do
		online=`cat /sys/devices/system/cpu/cpu${i}/online`
		if [ $online -eq 1 ]; then
			((little_num++))
		fi
	done

	big_num=0
	for i in 4 5 6 7
	do
		online=`cat /sys/devices/system/cpu/cpu${i}/online`
		if [ $online -eq 1 ]; then
			((big_num++))
		fi
		if [ $online -eq 1 -a $freq_big -eq 0 ]; then
			freq_big_path=`echo /sys/devices/system/cpu/cpu$i/cpufreq/cpuinfo_cur_freq`
			load_big_path=`echo /sys/bus/cpu/devices/cpu$i/cpufreq/interactive/cpu_util`
			[ -f $freq_big_path ] && freq_big=`cat $freq_big_path`
			[ -f $load_big_path ] && load_big=`cat $load_big_path`
		fi
	done

	if [ $power_gpu -ne 0 ]; then
		freq_gpu=`cat $freq_gpu_path`
		load_gpu=`cat $load_gpu_path`
	fi

        echo "online:$online_cpu, load_l:$load_little, freq_l:$freq_little, load_b:$load_big, freq_b:$freq_big, load_g:$load_gpu, freq_g:$freq_gpu"

	sleep $sample_cycle
	((loop++))
done

exit 0
