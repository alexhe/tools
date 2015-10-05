#!/bin/sh

TIMEOUT=

TRACE_PATH=/sys/kernel/debug/tracing
EVENT_PATH=$TRACE_PATH/events
SCHED_EVENT=$EVENT_PATH/sched

SCHED_EVENT_1=$SCHED_EVENT/sched_hmp_migrate
SCHED_EVENT_2=$SCHED_EVENT/sched_hmp_offload_abort
SCHED_EVENT_3=$SCHED_EVENT/sched_hmp_offload_succeed
SCHED_EVENT_4=$SCHED_EVENT/sched_migrate_task
SCHED_EVENT_5=$SCHED_EVENT/sched_hmp_migrate
SCHED_EVENT_6=$SCHED_EVENT/sched_task_load_contrib
SCHED_EVENT_7=$SCHED_EVENT/sched_rq_runnable_load
SCHED_EVENT_8=$SCHED_EVENT/sched_rq_runnable_ratio

HPS_EVENT=$EVENT_PATH/hotplug
FREQ_EVENT=$EVENT_PATH/power/cpu_frequency
IDLE_EVENT=$EVENT_PATH/power/cpu_idle

if [ ! -z $1 ]; then
	TIMEOUT=$1
else
	TIMEOUT=120
fi

# clear trace
echo "Clear ..."
adb shell "echo 0 > $TRACE_PATH/tracing_on"
adb shell "echo >$TRACE_PATH/trace"
echo 

# set buffer size
adb shell "echo 40960 >$TRACE_PATH/buffer_total_size_kb"

# enable sched event
echo "Start sched event ..."
adb shell "echo 1 > $SCHED_EVENT_1/enable"
#adb shell "echo 1 > $SCHED_EVENT_2/enable"
adb shell "echo 1 > $SCHED_EVENT_3/enable"
adb shell "echo 1 > $SCHED_EVENT_4/enable"
#adb shell "echo 1 > $SCHED_EVENT_5/enable"
#adb shell "echo 1 > $SCHED_EVENT_6/enable"
adb shell "echo 1 > $SCHED_EVENT_7/enable"
adb shell "echo 1 > $SCHED_EVENT_8/enable"

adb shell "echo 1 > $HPS_EVENT/enable"
adb shell "echo 1 > $FREQ_EVENT/enable"
adb shell "echo 1 > $IDLE_EVENT/enable"

adb shell "echo 1 > $TRACE_PATH/tracing_on"

echo
echo "Tracing ON, Please Do Test......"
echo

# show Timeout
b=''
for ((i=0;$i<=$TIMEOUT;i+=1))
do
    printf "Timeout:[%-50s]%d%%\r" $b $i
    sleep 1
    
    b=#$b
done
echo

echo "Tracing OFF, Please Wait to get trace file ..."
echo

adb shell "echo 0 > $TRACE_PATH/tracing_on"
adb pull $TRACE_PATH/trace ./

sleep 1 
echo "Finish!!!"
