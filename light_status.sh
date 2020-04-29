#!/bin/bash

light=22

## return value:
## 0 == on
## 1 == off
## 2 == neither?

if [ -f /dev/shm/lightson ]; then
	echo "On"
	exit
fi

if [ -d "/sys/class/gpio/gpio$light/" ]; then
	if [ "$(cat /sys/class/gpio/gpio$light/value)" -eq 1 ]; then
		echo "On"
		exit
	else
		echo "Off"
	fi
fi

echo "Neither"
