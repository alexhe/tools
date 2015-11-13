#!/bin/sh

dump_setting() {
#write parms to node
	echo "========= Little:==========="
	echo "/sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads" && adb shell "cat /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads"
	echo "/sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time" && adb shell "cat /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time"
	echo "/sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq" && adb shell "cat /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq"
	echo "/sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load" && adb shell "cat /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load"
	echo "/sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay" && adb shell "cat /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay"
	echo "/sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate" && adb shell "cat /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate"
 	echo "/sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack" && adb shell "cat /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack"
	echo "/sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration" && adb shell "cat /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration"

	#set big cpu parms
	echo "=========== BIG: ==========="
	echo "/sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads" && adb shell "cat /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads"
        echo "/sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time" && adb shell "cat /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time"
        echo "/sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq" && adb shell "cat /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq"
        echo "/sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load" && adb shell "cat /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load"
        echo "/sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay" && adb shell "cat /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay"
        echo "/sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate" && adb shell "cat /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate"
        echo "/sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack" && adb shell "cat /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack"
        echo "/sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse_duration" && adb shell "cat /sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse_duration"

}


#make sure adb run as root
adb root
sleep 2

#make sure cpu4 is online
adb shell "echo 1 > /sys/devices/system/cpu/cpu4/online"

dump_setting
