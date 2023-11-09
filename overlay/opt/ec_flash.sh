#!/bin/sh

if !(which wchisp);
then
	echo "wchisp not found"
	exit 1
fi

if [ "$1" = "" ]
then
	echo "usage: $0 firmware"
	exit 1
fi

EC_BOOT="504"

set -ux

echo $EC_BOOT > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio$EC_BOOT/direction

boot_high() {
	echo 1 > /sys/class/gpio/gpio$EC_BOOT/value
}

boot_low() {
	echo 0 > /sys/class/gpio/gpio$EC_BOOT/value
}

boot_high
sleep 13
wchisp config reset
wchisp flash $1
boot_low

