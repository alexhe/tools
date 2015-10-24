FILE=$1

function push_test
{
	adb -s $1 push $2 /data/local/tmp/1.tmp
	sleep 2
	adb -s $1 push $2 /data/local/tmp/2.tmp
	sleep 2
	adb -s $1 push $2 /data/local/tmp/3.tmp
	sleep 2
	adb -s $1 push $2 /data/local/tmp/4.tmp
	sleep 2
	adb -s $1 shell "rm -rf /data/local/tmp/*"
	adb -s $1 shell sync
}

i=0
while [ $i -lt 1000 ]
do
	for dev in `adb devices |grep -E "device\>" |awk '{print $1}'`
	do
        	push_test $dev $FILE
		sleep 2
		((i++))
		echo "Testing $i times ... ..."
	done
done
