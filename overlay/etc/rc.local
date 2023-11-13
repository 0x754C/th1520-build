#!/bin/sh

# set path
PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
export PATH

# setup usb host
/opt/usb-stack-restart.sh

# setup uart3 pinmux
# TODO: move it into devicetree
busybox devmem 0xFFE7F3C408 w 0x13

# for LicheeConsole4A
if (cat /proc/device-tree/model | grep LicheeConsole4A);
then
	echo 1 > /sys/class/graphics/fbcon/rotate_all
fi

# bluetooth driver
/usr/bin/hciattach ttyS4 any 1500000

# mipi2edp
modprobe lt8911exb

exit 0
