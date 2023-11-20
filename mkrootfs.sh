#!/usr/bin/env bash

if [ -z "$DISTRO" ]
then
	DISTRO="opensuse"
fi

if [ -z "$MMDEBSTRAP" ]
then
	MMDEBSTRAP=mmdebstrap
fi

if [ -z "$GENTOO_ROOTFS_URL" ]
then
	GENTOO_ROOTFS_URL="https://mirrors.ustc.edu.cn/gentoo/releases/riscv/autobuilds/current-stage3-rv64_lp64-systemd-mergedusr/stage3-rv64_lp64-systemd-mergedusr-20231110T170202Z.tar.xz"
fi

if [ -z "$OPENSUSE_ROOTFS_URL" ]
then
	OPENSUSE_ROOTFS_URL="https://mirrors.nju.edu.cn/opensuse/ports/riscv/tumbleweed/images/openSUSE-Tumbleweed-RISC-V-LXQT.riscv64-rootfs.riscv64.tar.xz"
fi

mkdir build

set -eux

genrootfs_revyos() {
}

genrootfs_gentoo() {
	curl $GENTOO_ROOTFS_URL | xz -d -c - > build/rootfs.tar
}

genrootfs_opensuse() {
	curl $OPENSUSE_ROOTFS_URL | xz -d -c > build/rootfs.tar
}

case "$DISTRO" in
	revyos)
		genrootfs_revyos
		;;
	gentoo)
		genrootfs_gentoo
		;;
	opensuse)
		genrootfs_opensuse
		;;
	*)
		echo "nop"
		;;
esac

cd overlay
for i in *
do
tar --append --file=../build/rootfs.tar $i
done
cd ..
