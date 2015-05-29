#!/system/bin/sh
#
# record the temp for M71
#

# Path
online_cpu_path=/sys/devices/system/cpu/online

freq_little_path=/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
#freq_big_path=/sys/devices/system/cpu/cpu4/cpufreq/scaling_cur_freq

load_little_path=/sys/devices/system/cpu/cpufreq/interactive/percpu_load
#load_big_path=/sys/bus/cpu/devices/cpu4/cpufreq/interactive/cpu_util

#power_gpu_path=/sys/bus/platform/devices/14ac0000.mali/power_state
#freq_gpu_path=/sys/bus/platform/devices/14ac0000.mali/clock
#load_gpu_path=/sys/bus/platform/devices/14ac0000.mali/utilization
load_gpu_path=/proc/mali/utilization 

# memory
#freq_mif_path=/sys/class/devfreq/exynos5-devfreq-mif/cur_freq

# bus
#freq_int_path=/sys/class/devfreq/exynos5-devfreq-int/cur_freq

# disp
#freq_disp_path=/sys/class/devfreq/exynos5-devfreq-disp/cur_freq

# isp
#freq_isp_path=/sys/class/devfreq/exynos5-devfreq-isp/cur_freq

temp_cpu_path=/sys/class/thermal/thermal_zone7/temp     # mtktscpu
temp_bat_path=/sys/class/thermal/thermal_zone8/temp     # mtktsbattery
temp_board_path=/sys/class/thermal/thermal_zone6/temp     # mtktsAP

#current_bat_path=/sys/class/power_supply/battery/current_now
#voltage_bat_path=/sys/class/power_supply/battery/voltage_now

# Calculate perf
cpu_dmips=350
kfc_dmips=186

sample_cycle=1
[ -n "$1" ] && sample_cycle=$1

sample_loop=9999999999
[ -n "$2" ] && sample_loop=$2

get_average=0
[ -n "$3" ] && get_average=$3

total_current=0
total_voltage=0
total_power=0
total_perf=0
total_big=0
total_little=0
total_freq_l=0
total_freq_b=0
total_freq_g=0
total_freq_m=0
total_freq_i=0
total_freq_d=0
total_freq_c=0
total_temp_c=0
total_temp_b=0
total_temp_n=0

loop=1

while [ $loop -le $sample_loop ];
do
	freq_big=0
	load_big="OFF OFF OFF OFF"
	load_little=0
	load_gpu=0
	freq_gpu=0
	current_bat=0

	power_gpu= #`cat $power_gpu_path`
	online_cpu=`cat $online_cpu_path`
	freq_little=`cat $freq_little_path`
	load_little=`cat $load_little_path`

	#freq_mif=`cat $freq_mif_path`
	#freq_int=`cat $freq_int_path`

	#freq_disp=`cat $freq_disp_path`
	#freq_isp=`cat $freq_isp_path`

	temp_cpu=`cat $temp_cpu_path`
	temp_bat=`cat $temp_bat_path`
	temp_board=`cat $temp_board_path`
	#current_bat=`cat $current_bat_path`
	#voltage_bat=`cat $voltage_bat_path`
	power_bat=0

    load_gpu=`cat $load_gpu_path`

	little_num=0
	for i in 0 1 2 3
	do
		online=`cat /sys/devices/system/cpu/cpu${i}/online`
		if [ $online -eq 1 ]; then
			((little_num++))
		fi
	done

	((temp_cpu=temp_cpu))

#        echo "on:$online_cpu, l:$little_num, b:$big_num, load_l:$load_little, freq_l:$freq_little, load_b:$load_big, freq_b:$freq_big, load_g:$load_gpu, freq_g:$freq_gpu, freq_m:$freq_mif, freq_i:$freq_int, freq_d:$freq_disp, freq_c:$freq_isp, temp_c:$temp_cpu, temp_n:$temp_board, temp_b:$temp_bat, cur:$current_bat, vol:$voltage_bat, power:$power_bat, perf:$perf"

        echo "on:$online_cpu, l:$little_num, load_l:$load_little, freq_l:$freq_little, load_g:$load_gpu, temp_c:$temp_cpu, temp_n:$temp_board, temp_b:$temp_bat"

	#((total_power+=power_bat))
	#((total_current+=current_bat))
	#((total_voltage+=voltage_bat))
	#((total_perf+=perf))

	((total_little+=little_num))
	#((total_big+=big_num))
	((total_freq_l+=freq_little))
	#((total_freq_b+=freq_big))
	#((total_freq_g+=freq_gpu))
	#((total_freq_m+=freq_mif))
	#((total_freq_i+=freq_int))
	#((total_freq_d+=freq_disp))
	#((total_freq_c+=freq_isp))
	((total_temp_c+=temp_cpu))
	((total_temp_b+=temp_bat))
	((total_temp_n+=temp_board))

	sleep $sample_cycle
	((loop++))
done

#((current_avg=total_current/sample_loop))
#((voltage_avg=total_voltage/sample_loop))
#((power_avg=total_power/sample_loop))
#((perf_avg=total_perf/sample_loop))
((little_avg=total_little/sample_loop))
#((big_avg=total_big/sample_loop))
((freq_l_avg=total_freq_l/sample_loop))
#((freq_b_avg=total_freq_b/sample_loop))
#((freq_g_avg=total_freq_g/sample_loop))
#((freq_m_avg=total_freq_m/sample_loop))
#((freq_i_avg=total_freq_i/sample_loop))
#((freq_d_avg=total_freq_d/sample_loop))
#((freq_c_avg=total_freq_c/sample_loop))
((temp_c_avg=total_temp_c/sample_loop))
((temp_b_avg=total_temp_b/sample_loop))
((temp_n_avg=total_temp_n/sample_loop))

if [ $get_average -ne 0 ]; then
#	echo "on:$online_cpu, l:$little_avg, b:$big_avg, load_l:$load_little, freq_l:$freq_l_avg, load_b:$load_big, freq_b:$freq_b_avg, freq_g:$freq_g_avg, freq_m:$freq_m_avg, freq_i:$freq_i_avg, freq_d:$freq_d_avg, freq_c:$freq_c_avg, temp_c:$temp_c_avg, temp_n:$temp_n_avg, temp_b:$temp_b_avg, cur:$current_avg, vol:$voltage_avg, power:$power_avg, perf:$perf_avg (avg)"
	echo "on:$online_cpu, l:$little_avg, load_l:$load_little, freq_l:$freq_l_avg, temp_c:$temp_c_avg, temp_n:$temp_n_avg, temp_b:$temp_b_avg"
fi

exit 0
