#!/bin/bash

## run the check. if it's between the hours of $ontime and $offtime, the lights should be on

ontime=08
offtime=17

outlet1=22
outlet2=23

logfile="/home/pi/bin/garden/garden.log"

# if the override has been active for more than a minute, rm the file
find /dev/shm/ -maxdepth 1 -type f -name lightson -cmin +5 -print -delete | tee -a "$logfile"

if [ -f /dev/shm/lightson ]; then
	## if that file exists, ensure the light is on and exit
	echo "$(date) Light override file found." | tee -a "$logfile"
	echo 1 > /sys/class/gpio/gpio$outlet1/value
	echo 1 > /sys/class/gpio/gpio$outlet2/value
	exit 0
fi

## setup pin for userspace, default lights to 'off'
if [ ! -d "/sys/class/gpio/gpio$outlet1/" ]; then
	#echo "exporting pin"
	echo "$(date) Setting up first relay" | tee -a "$logfile"
	echo $outlet1 > /sys/class/gpio/export
	sleep .5
	#echo "setting pin as out"
	echo "out" > "/sys/class/gpio/gpio$outlet1/direction"
	sleep .5
	#echo "defaulting lights to off"
	echo 0 > "/sys/class/gpio/gpio$outlet1/value"
	sleep .5
fi

if [ ! -d "/sys/class/gpio/gpio$outlet2/" ]; then
	echo "$(date) Setting up second relay" | tee -a "$logfile"
	echo $outlet2 > /sys/class/gpio/export
	sleep .5
	echo "out" > "/sys/class/gpio/gpio$outlet2/direction"
	sleep .5
	echo 0 > "/sys/class/gpio/gpio$outlet2/value"
	sleep .5
fi

## do the check, control lights accordingly
hr=$(date +%H)
#echo "hr is $hr"

if [ $hr -ge $ontime ] && [ $hr -lt $offtime ]; then
	if [ $(cat /sys/class/gpio/gpio$outlet1/value) -eq 0 ]; then
		# need to toggle
		echo "$(date) Activating first relay" | tee -a "$logfile"
		echo 1 > /sys/class/gpio/gpio$outlet1/value
	fi
	if [ $(cat /sys/class/gpio/gpio$outlet2/value) -eq 0 ]; then
		echo "$(date) Activating second relay" | tee -a "$logfile"
		echo 1 > /sys/class/gpio/gpio$outlet2/value
	fi
else
	if [ $(cat /sys/class/gpio/gpio$outlet1/value) -eq 1 ]; then
		# need to toggle
		echo "$(date) Deactivating first relay" | tee -a "$logfile"
		echo 0 > /sys/class/gpio/gpio$outlet1/value
	fi
	if [ $(cat /sys/class/gpio/gpio$outlet2/value) -eq 1 ]; then
		echo "$(date) Deactivating second relay" | tee -a "$logfile"
		echo 0 > /sys/class/gpio/gpio$outlet2/value
	fi
fi

