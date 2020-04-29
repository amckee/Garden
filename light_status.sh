#!/bin/bash

. pins

## return value:
## 0 == on
## 1 == off
## 2 == neither?

if [ -f /dev/shm/lightson ]; then
	echo "On"
	exit
fi

if [ -d "/sys/class/gpio/gpio$outlet1/" ]; then
	if [ "$(cat /sys/class/gpio/gpio$outlet1/value)" -eq 1 ]; then
		echo "On"
		exit
	else
		echo "Off"
		exit
	fi
fi

echo "Neither"
