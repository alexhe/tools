#!/bin/bash

UTILS_ROOT=$PWD/utils/
SW_OSC=$UTILS_ROOT/oscillograph/oscilloscope

adb_pm_qos_path=/sys/power/adb_pm_qos

usb_charge_online_path=/sys/class/power_supply/charger/online
stop_usb_power_path=/sys/class/charger_class/charger_device/reg_control

online_cpu_path=/sys/devices/system/cpu/online

freq_little_path=/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
freq_big_path=/sys/devices/system/cpu/cpu4/cpufreq/scaling_cur_freq

load_little_path=/sys/bus/cpu/devices/cpu0/cpufreq/interactive/cpu_util
load_big_path=/sys/bus/cpu/devices/cpu4/cpufreq/interactive/cpu_util

power_gpu_path=/sys/bus/platform/devices/14ac0000.mali/power_state
freq_gpu_path=/sys/bus/platform/devices/14ac0000.mali/clock
load_gpu_path=/sys/bus/platform/devices/14ac0000.mali/utilization

# memory
freq_mif_path=/sys/class/devfreq/exynos5-devfreq-mif/cur_freq

# bus
freq_int_path=/sys/class/devfreq/exynos5-devfreq-int/cur_freq

# disp
freq_disp_path=/sys/class/devfreq/exynos5-devfreq-disp/cur_freq

# isp
freq_isp_path=/sys/class/devfreq/exynos5-devfreq-isp/cur_freq

# temp
#temp_cpu_path=/sys/class/thermal/thermal_zone0/temp
temp_cpu_path=/sys/devices/10060000.tmu/cpu_temp
temp_bat_path=/sys/class/power_supply/battery/temp
temp_board_path=/sys/devices/10060000.tmu/ntc_temp

# current
current_bat_path=/sys/class/power_supply/battery/current_now

path=($online_cpu_path $freq_little_path $freq_big_path $freq_gpu_path $freq_mif_path $freq_int_path $freq_disp_path $freq_isp_path $load_little_path $load_big_path $temp_bat_path $temp_cpu_path $temp_board_path $current_bat_path)

#
# main
#

samples=100
sample_time=0.001
multiple_num=1
multiple_nums=(1 0.001 0.001 1 0.001 0.001 0.001 0.001 0.001 0.001 0.1 0.001 0.0001 1)
sample_times=(0.1 0.02 0.02 0.02 0.02 0.02 0.02 0.02 0.02 0.02 0.02 0.5 0.1 0.5 0.01)

# Get choice

echo "======================================"
echo "     Available Data ...               "
echo "======================================"
echo ""
echo "     1. online_cpus                   "
echo "     2. little_freq                   "
echo "     3. big_freq                      "
echo "     4. gpu_freq                      "
echo "     5. mif_freq                      "
echo "     6. int_freq                      "
echo "     7. disp_freq                     "
echo "     8. isp_freq                      "
echo "     9. little_load                   "
echo "    10. big_load                      "
echo "    11. bat_temp                      "
echo "    12. cpu_temp                      "
echo "    13. board_temp                    "
echo "    14. bat_current                   "
echo "    15. all above                     "
echo ""
echo "======================================"

data_type=1
read -p "Please input the data want to draw: " input_data_type

# Check choice

min=1
max=15
((current_index=max-1))

[ -n "$input_data_type" ] && data_type=$input_data_type

if ! [ -n "$data_type" -a "$data_type" -le $max -a "$data_type" -ge $min ]; then
	echo -e "\nError: Please input number from $min to $max\n"
	exit 1
fi

if [ $data_type -le $current_index ]; then
	let path_index=$data_type-1
	current_path=${path[$path_index]}
	echo -e "\n	data path: $current_path\n"
	multiple_num=${multiple_nums[$path_index]}
	sample_time=${sample_times[$path_index]}
fi

# Get sample time

read -p "Please input the sample time (default: $sample_time): " input_sample_time
[ -n "$input_sample_time" ] && sample_time=$input_sample_time

echo -e "\n	sample_time: $sample_time\n"

# get all data

function get_all_data
{
	while :;
	do
		freq_big=0
		load_big="OFF OFF OFF OFF"
		load_little=0
		load_gpu=0
		freq_gpu=0
		current_bat=0

		adb devices | tail -2 | head -1 | grep List
		if [ $? -eq 0 ]; then
			echo -e "\n\nWarn: Adb disconnected... please plug in your usb device.\n\n"
			exit 1
		fi

		power_gpu=`adb shell cat $power_gpu_path | col -bp | tr -d '\n'`
		#echo "power_gpu: $power_gpu"
		online_cpu=`adb shell cat $online_cpu_path | col -bp | tr -d '\n'`
		#echo "online_cpu: $online_cpu"
		freq_little=`adb shell cat $freq_little_path| col -bp | tr -d '\n'`
		#echo "freq_little: $freq_little"
		load_little=`adb shell cat $load_little_path| col -bp | tr -d '\n'`
		#echo "load_little: $load_little"

		freq_mif=`adb shell cat $freq_mif_path| col -bp | tr -d '\n'`
		#echo "freq_mif: $freq_mif"
		freq_int=`adb shell cat $freq_int_path| col -bp | tr -d '\n'`
		#echo "freq_int: $freq_int"

		freq_disp=`adb shell cat $freq_disp_path| col -bp | tr -d '\n'`
		#echo "freq_disp: $freq_disp"
		freq_isp=`adb shell cat $freq_isp_path| col -bp | tr -d '\n'`
		#echo "freq_isp: $freq_isp"

		temp_cpu=`adb shell cat $temp_cpu_path| col -bp | tr -d '\n'`
		#echo "temp_cpu: $temp_cpu"
		temp_bat=`adb shell cat $temp_bat_path| col -bp | tr -d '\n'`
		#echo "temp_bat: $temp_bat"
		temp_board=`adb shell cat $temp_board_path| col -bp | tr -d '\n'`
		#echo "temp_board: $temp_board"
		current_bat=`adb shell cat $current_bat_path| col -bp | tr -d '\n'`
		#echo "current_bat: $current_bat"

		for i in 4 5 6 7
		do
			online=`adb shell cat /sys/devices/system/cpu/cpu${i}/online | col -bp | tr -d '\n'`
			if [ -n "$online" -a $online -eq 1 ]; then
				freq_big_path=`echo /sys/devices/system/cpu/cpu$i/cpufreq/scaling_cur_freq`
				freq_big=`adb shell cat $freq_big_path| col -bp | tr -d '\n'`
				echo "$freq_big" | grep -q "No such file or directory"
				[ $? -eq 0 ] && freq_big=0

				load_big_path=`echo /sys/bus/cpu/devices/cpu$i/cpufreq/interactive/cpu_util`
				load_big=`adb shell cat $load_big_path| col -bp | tr -d '\n'`
				echo "$load_big" | grep -q "No such file or directory"
				[ $? -eq 0 ] && load_big="OFF OFF OFF OFF"
				break
			fi
		done

		if [ -n "$power_gpu" ] && [ "$power_gpu" -ne 0 ]; then
			freq_gpu=`adb shell cat $freq_gpu_path| col -bp | tr -d '\n'`
			load_gpu=`adb shell cat $load_gpu_path| col -bp | tr -d '\n'`
		fi

		echo "on: $online_cpu, load_l: $load_little, freq_l: $freq_little, load_b: $load_big, freq_b: $freq_big, load_g: $load_gpu, freq_g: $freq_gpu, freq_m: $freq_mif, freq_i: $freq_int, freq_d: $freq_disp, freq_c: $freq_isp, temp_c: $temp_cpu, temp_n: $temp_board, temp_b: $temp_bat, current: $current_bat"

		sleep $sample_time
	done
}

# Generate the sampling command

if [ $data_type -eq 1 ]; then
	get_data_cmd="\"total=0; for i in 0 1 2 3 4 5 6 7; do online=\\\$(cat /sys/devices/system/cpu/cpu\\\$i/online); [ \\\$online -eq 1 ] && ((total++)); done; echo \\\${total}\""
	scope_args=" -l online_cpus -u N -m 10"
elif [ $data_type -le $current_index ]; then
	get_data_cmd="\"cat $current_path\""
else
	get_all_data
fi

get_data_cmd_single="adb shell $get_data_cmd | tr -d '-'"

echo -e "\n	sample command (single): $get_data_cmd_single"

get_data_cmd_loop="while :; do $get_data_cmd_single; sleep $sample_time; done"

# Disable the adb pm qos
adb shell "echo 0 > $adb_pm_qos_path"
echo -e "\n	Warning: To get cpufreq data, please disable adb pm qos via: echo 0 > $adb_pm_qos_path\n"
adb shell "echo 0 > $usb_charge_online_path"
echo -e "\n	Warning: To get current data, please disable usb charging: echo 0 > $usb_charge_online_path\n"
adb shell "echo write b7 0 > $stop_usb_power_path"
echo -e "\n	Warning: To get current data, please disable usb charging: echo write b7 0 > $stop_usb_power_path\n"


# Get draw or sample

draw_it=0

if [ $data_type -ne 7 -a $data_type -ne 8 ]; then
	read -p "Do you want to draw the data (1/0, default=0)? " input_draw_it
else
	intput_draw_it=0
fi

[ -n "$input_draw_it" ] && draw_it=$input_draw_it

# sample the data or draw the data

adb devices | tail -2 | head -1 | grep List
if [ $? -eq 0 ]; then
	echo -e "\n\nWarn: Adb disconnected... please plug in your usb device.\n\n"
	exit 1
fi

if [ "$draw_it" -eq 1 ]; then

	read -p "Please input the multiple number (default: $multiple_num): " input_multiple_num
	[ -n "$input_multiple_num" ] && multiple_num=$input_multiple_num

	echo -e "\n	multiple_num: $multiple_num\n"


	draw_command="$get_data_cmd_loop | $SW_OSC -f0 -s $samples $scope_args -M $multiple_num -m 10 2>/dev/null"
	echo -e "\n	draw_command: $draw_command\n"
	eval $draw_command
else
	echo -e "\n	sample command(loop)  : $get_data_cmd_loop\n"
	echo -e "\n	sample data: \n"
	eval $get_data_cmd_loop
fi
