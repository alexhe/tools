#!/bin/sh

TIMEOUT=

TRACE_PATH=/sys/kernel/debug/tracing
EVENT_PATH=$TRACE_PATH/events
SCHED_EVENT=$EVENT_PATH/sched
HPS_EVENT=$EVENT_PATH/hotplug

if [ ! -z $1 ]; then
	TIMEOUT=$1
else
	TIMEOUT=120
fi

#clear trace'
echo "Clear ..."
adb shell "echo 0 > $TRACE_PATH/tracing_on"
adb shell "echo >$TRACE_PATH/trace"
echo 

# enable sched event
echo "Start sched event ..."
adb shell "echo 1 > $SCHED_EVENT/enable"
adb shell "echo 1 > $HPS_EVENT/enable"
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
