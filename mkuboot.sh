#!/usr/bin/env bash

mkdir -p build

if [ -z "$URL" ]
then
	export URL="https://github.com/revyos/thead-u-boot"
fi

if [ -z "$BRANCH" ]
then
	export BRANCH="lpi4a"
fi

if [ -z "$CROSS_COMPILE" ]
then
	export CROSS_COMPILE="riscv64-linux-gnu-"
fi

set -eux

if [ ! -e build/uboot ] 
then
	git clone $URL build/uboot --branch=${BRANCH}
	cd build/uboot
	find ../../uboot/ -name *.patch | sort | while read line
	do
		patch -p1 < $line
	done
	cd ../../
fi

cd build/uboot
export ARCH=riscv
make clean
make light_lpi4a_defconfig
make -j$(nproc)
cp u-boot-with-spl.bin ../u-boot-with-spl-sbc.bin
make clean
make light_lpi4a_16g_defconfig
make -j$(nproc)
cp u-boot-with-spl.bin ../u-boot-with-spl-sbc-16g.bin
make clean
make light_lpi4a_console_defconfig
cp ../../overlay/boot/logos/sipeed-console.bmp tools/logos/custom.bmp
make -j$(nproc)
cp u-boot-with-spl.bin ../u-boot-with-spl-console.bin
make clean
make light_lpi4a_z14inch_m1_defconfig
make -j$(nproc)
cp u-boot-with-spl.bin ../u-boot-with-spl-z14inch-m1.bin
