#!/bin/sh

n=0
DEV_NAME=A10ACL2JFMDQ

while(($n < 1000))
do
	`adb -s $DEV_NAME wait-for-device` 
	sleep 100 
	adb -s $DEV_NAME shell reboot
	((n++ ))
	echo "rebooting ... $n times"
done
