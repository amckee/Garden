#!/bin/bash

cd $(dirname "$0")
. pins

if [ ! -d "/sys/class/gpio/gpio$button/" ]; then
	echo "$(date) Setting up button" | tee -a "$logfile"
	echo $button > /sys/class/gpio/export
	sleep .5
	echo "in" > "/sys/class/gpio/gpio$button/direction"
	sleep .5
fi

while sleep .2; do
	val=$(cat "/sys/class/gpio/gpio$button/value")
	if [ "$val" -eq 1 ]; then
	        echo "$(date) Button pushed; override activated" | tee -a "$logfile"
	        touch /dev/shm/lightson
	        echo 0 > "/sys/class/gpio/gpio$outlet1/value"
	fi
done

