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

echo "$(date) Manual override. Toggling lights." | tee -a "$logfile"
val=$(cat "/sys/class/gpio/gpio$outlet1/value")
echo "val is $val"
if [ "$val" -eq 0 ]; then
	# lights are off; turn them on
	echo "turning lights on"
	touch /dev/shm/lightson
	echo 1 > "/sys/class/gpio/gpio$outlet1/value"
	echo 1 > "/sys/class/gpio/gpio$outlet2/value"
else
	# lights are on; turn them off
	echo "turning lights off"
	rm /dev/shm/lightson
	echo 0 > "/sys/class/gpio/gpio$outlet1/value"
	echo 0 > "/sys/class/gpio/gpio$outlet2/value"
fi

