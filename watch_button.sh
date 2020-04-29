#!/bin/bash

btn=27
light=22
logfile="/home/pi/bin/garden/garden.log"

if [ ! -d "/sys/class/gpio/gpio$btn/" ]; then
	echo "$(date) Setting up button" | tee -a "$logfile"
	echo $btn > /sys/class/gpio/export
	sleep .5
	echo "in" > "/sys/class/gpio/gpio$btn/direction"
	sleep .5
fi

while sleep .2; do
	val=$(cat "/sys/class/gpio/gpio$btn/value")
	if [ "$val" -eq 1 ]; then
	        echo "$(date) Button pushed; override activated" | tee -a "$logfile"
	        touch /dev/shm/lightson
	        #echo 0 > "/sys/class/gpio/gpio$light/value"
	fi
done


/home/pi/bin/garden/light_control.sh
