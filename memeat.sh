#!/bin/sh

SIZE=0

if [ -n "$1" ]; then
	SIZE=$1
else
	SIZE=1800M
fi

#run adb as root
adb root && sleep 2 

#kill the before running process.
PREPID=`adb shell ps |grep memtester |awk '{print $2}'`
echo $PREPID
if [ -n "$PREPID" ]; then
	adb shell "kill -s 9 $PREPID"
fi

sleep 2

# eat memory
adb shell /data/memtester $SIZE &

#get pid 
PID=`adb shell ps |grep memtester |awk '{print $2}'`
echo $PID

# change adj
adb shell "echo -1000 >/proc/$PID/oom_score_adj"
