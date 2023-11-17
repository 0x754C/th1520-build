#!/usr/bin/env bash

set -eux

if [ $(id -u) -ne 0 ]
then
	echo "usage: fakeroot sh $0"
	exit 1
fi


rm -rf build/rootfs
rm -rf build/rootfs.ext4
rm -rf build/rootfs.ext4.lz4
rm -rf build/bootfs.ext4
rm -rf build/bootfs.ext4.lz4
mkdir -v build/rootfs
tar -xpf build/rootfs.tar -C ./build/rootfs/
dd if=/dev/zero of=./build/bootfs.ext4 bs=1M count=128
dd if=/dev/zero of=./build/rootfs.ext4 bs=1M count=4000
mkfs.ext4 -d ./build/rootfs/boot -L lpi4a-boot ./build/bootfs.ext4
rm -rf build/rootfs/boot/*
mkfs.ext4 -d ./build/rootfs -L lpi4a-root ./build/rootfs.ext4
lz4 -z -v ./build/bootfs.ext4 > ./build/bootfs.ext4.lz4
lz4 -z -v ./build/rootfs.ext4 > ./build/rootfs.ext4.lz4
rm -rf ./build/rootfs
exit 0
