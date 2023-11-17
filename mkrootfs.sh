#!/usr/bin/env bash

if [ -z "$DISTRO" ]
then
	DISTRO="revyos"
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
echo "deb https://mirror.iscas.ac.cn/revyos/revyos-gles-21/ revyos-gles-21 main
deb https://mirror.iscas.ac.cn/revyos/revyos-base/ sid main contrib non-free non-free-firmware
deb https://mirror.iscas.ac.cn/revyos/revyos-kernels/ revyos-kernels main
deb https://mirror.iscas.ac.cn/revyos/revyos-addons/ revyos-addons main
" | $MMDEBSTRAP --architectures=riscv64 -v -d \
	--include="ca-certificates debian-ports-archive-keyring revyos-keyring \
	thead-gles-addons th1520-boot-firmware locales dosfstools binutils \
	file tree sudo bash-completion openssh-server network-manager gnupg \
	dnsmasq-base libpam-systemd ppp wireless-regdb wpasupplicant \
	libengine-pkcs11-openssl iptables systemd-timesyncd vim usbutils \
	libgles2 parted exfatprogs systemd-sysv mesa-vulkan-drivers nftables \
	glmark2-es2 mesa-utils vulkan-tools iperf3 stress-ng avahi-daemon \
	unifont xfonts-unifont tmux screen i2c-tools net-tools ethtool xdotool \
	ckermit lrzsz minicom picocom btop neofetch iotop htop bmon \
	chromium libqt5gui5-gles vlc gimp gimp-data-extras \
	gimp-plugin-registry gimp-gmic irssi e2fsprogs blueman \
	autoconf automake m4 texinfo grep gawk sed patch diffutils git flex \
	bison libusb-dev cmake build-essential cscope clangd indent code-oss \
	qtcreator emacs nvi wireshark tcpdump cataclysm-dda-sdl \
	nethack-console fcitx5 fcitx5-rime rime-data-luna-pinyin \
	fcitx5-frontend-gtk2 fcitx5-frontend-gtk3 fcitx5-frontend-gtk4 \
	fcitx5-frontend-qt5 fcitx5-config-qt fcitx5-frontend-qt6 eject \
	network-manager-gnome lightdm \
	desktop-base xorg alsa-utils pulseaudio dbus-user-session udisks2 \
	polkitd squashfs-tools xfce4 xinit xinput evtest device-tree-compiler\
	xfce4-terminal busybox xfce4-power-manager xfce4-power-manager-data \
	xfce4-power-manager-plugins xfce4-battery-plugin xfce4-cpugraph-plugin \
	xfce4-screensaver linux-cpupower bc dc u-boot-tools libnss-mdns \
	" > ./build/rootfs.tar
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
