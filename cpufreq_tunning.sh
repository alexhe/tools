#!/bin/sh

DEBUG=1

#DEF TEST VALUE
TARGET_LOADS_L='75 800000:85 1100000:95'
TARGET_LOADS_B='80 1000000:81 1400000:87 1700000:90'

MIN_SIMPLE_TIME_L=40000
MIN_SIMPLE_TIME_B=40000

HISPEED_FREQ_L=800000
HISPEED_FREQ_B=1000000

GO_HISPEED_LOAD_L=85
GO_HISPEED_LOAD_B=89

ABOVE_HISPEED_DELAY_L='19000 1000000:39000'
ABOVE_HISPEED_DELAY_B='59000 1200000:119000 1700000:19000'

TIMER_RATE_L=20000
TIMER_RATE_B=20000

TIMER_SLACK_L=20000
TIMER_SLACK_B=20000

BOOSTPULSE_DURATION_L=40000
BOOSTPULSE_DURATION_B=40000

usage() {
    echo "Usage: $1: [-lL target_loads][-gG go_hispeed_load] [-fF hispeed_freq] [-aA above_hispeed_delay] [-bB boostpulse_duration]" 
    echo "  -l  TARGET_LOADS_L"
    echo "  -L  TARGET_LOADS_B"
    echo "  -g  GO_HISPEED_LOAD_L"
    echo "  -G  GO_HISPEED_LOAD_B"
    echo "  -f  HISPEED_FREQ_L"
    echo "  -F  HISPEED_FREQ_B"
    echo "  -a  ABOVE_HISPEED_DELAY_L"
    echo "  -A  ABOVE_HISPEED_DELAY_B"
    echo "  -b  BOOSTPULSE_DURATION_L"
    echo "  -B  BOOSTPULSE_DURATION_B"
    echo "  -h  show help"
    exit 1
}

dump_params() {
    echo "  TARGET_LOADS_L	$TARGET_LOADS_L"
    echo "  TARGET_LOADS_B  	$TARGET_LOADS_B"
    echo "  GO_HISPEED_LOAD_L	$GO_HISPEED_LOAD_L"
    echo "  GO_HISPEED_LOAD_B	$GO_HISPEED_LOAD_B"
    echo "  HISPEED_FREQ_L	$HISPEED_FREQ_L"
    echo "  HISPEED_FREQ_B	$HISPEED_FREQ_B"
    echo "  ABOVE_HISPEED_DELAY_L	$ABOVE_HISPEED_DELAY_L"
    echo "  ABOVE_HISPEED_DELAY_B	$ABOVE_HISPEED_DELAY_B"
    echo "  BOOSTPULSE_DURATION_L	$BOOSTPULSE_DURATION_L"
    echo "  BOOSTPULSE_DURATION_B 	$BOOSTPULSE_DURATION_B"
}

dump_setting() {
#write parms to node
	echo "Get Little cpu freq paras."
	echo "/sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads" && adb shell "cat /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads"
	echo "/sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time" && adb shell "cat /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time"
	echo "/sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq" && adb shell "cat /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq"
	echo "/sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load" && adb shell "cat /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load"
	echo "/sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay" && adb shell "cat /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay"
	echo "/sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate" && adb shell "cat /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate"
 	echo "/sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack" && adb shell "cat /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack"
	echo "/sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration" && adb shell "cat /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration"

	#set big cpu parms
	echo "Get BIG cpu freq paras."
	echo "/sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads" && adb shell "cat /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads"
        echo "/sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time" && adb shell "cat /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time"
        echo "/sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq" && adb shell "cat /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq"
        echo "/sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load" && adb shell "cat /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load"
        echo "/sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay" && adb shell "cat /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay"
        echo "/sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate" && adb shell "cat /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate"
        echo "/sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack" && adb shell "cat /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack"
        echo "/sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse_duration" && adb shell "cat /sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse_duration"

}

while getopts "l:L:g:G:f:F:a:A:b:B:h" arg
do
    case $arg in
        l)  TARGET_LOADS_L=$OPTARG;;
        L)  TARGET_LOADS_B=$OPTARG;;
        g)  GO_HISPEED_LOAD_L=$OPTARG;;
        G)  GO_HISPEED_LOAD_B=$OPTARG;;
        f)  HISPEED_FREQ_L=$OPTARG;;
        F)  HISPEED_FREQ_B=$OPTARG;;
        a)  ABOVE_HISPEED_DELAY_L=$OPTARG;;
        A)  ABOVE_HISPEED_DELAY_B=$OPTARG;;
        b)  BOOSTPULSE_DURATION_L=$OPTARG;;
        B)  BOOSTPULSE_DURATION_B=$OPTARG;;
        h)  usage $0;;
    esac
done

[ -z "$TARGET_LOADS_L" ] && usage $0  
[ -z "$TARGET_LOADS_B" ] && usage $0
[ -z "$GO_HISPEED_LOAD_L" ] && usage $0
[ -z "$GO_HISPEED_LOAD_B" ] && usage $0
[ -z "$HISPEED_FREQ_L" ] && usage $0
[ -z "$HISPEED_FREQ_B" ] && usage $0
[ -z "$ABOVE_HISPEED_DELAY_L" ] && usage $0
[ -z "$ABOVE_HISPEED_DELAY_B" ] && usage $0
[ -z "$BOOSTPULSE_DURATION_L" ] && usage $0
[ -z "$BOOSTPULSE_DURATION_B" ] && usage $0


[ ! -z $DEBUG ] && dump_params

#make sure cpu4 is online
echo "Disable HPS and on CPU4."
adb shell "echo 0 >/sys/power/hps_enabled"
sleep 5
adb shell "echo 1 > /sys/devices/system/cpu/cpu4/online"

#write parms to node
echo "Set Little cpu freq paras."
adb shell "echo $TARGET_LOADS_L >/sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads"
adb shell "echo $MIN_SIMPLE_TIME_L >/sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time"
adb shell "echo $HISPEED_FREQ_L >/sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq"
adb shell "echo $GO_HISPEED_LOAD_L >/sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load"
adb shell "echo $ABOVE_HISPEED_DELAY_L >/sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay"
adb shell "echo $TIMER_RATE_L >/sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate"
adb shell "echo $TIMER_SLACK_L >/sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack"
adb shell "echo $BOOSTPULSE_DURATION_L >/sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration"

#set big cpu parms
echo "Set BIG cpu freq paras."
adb shell "echo $TARGET_LOADS_B >/sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads"
adb shell "echo $MIN_SIMPLE_TIME_B >/sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time"
adb shell "echo $HISPEED_FREQ_B >/sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq"
adb shell "echo $GO_HISPEED_LOAD_B >/sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load"
adb shell "echo $ABOVE_HISPEED_DELAY_B >/sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay"
adb shell "echo $TIMER_RATE_B >/sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate"
adb shell "echo $TIMER_SLACK_B >/sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack"
adb shell "echo $BOOSTPULSE_DURATION_B >/sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse_duration"

if [ ! -z $DEBUG ]; then 
    echo "Read and dump cpufreq params"
    dump_setting
fi

#enable hps
echo "Enable HPS."
adb shell "echo 1 >/sys/power/hps_enabled"
sleep 5

echo "CPUfreq Params set success!"
