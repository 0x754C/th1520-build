#!/bin/bash

# delay some time before setup
sleep 20

PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
export PATH

# use all emmc free space for rootfs
parted -s /dev/mmcblk0 "resizepart 3 -0"
# resize root filesystem
resize2fs /dev/mmcblk0p2
resize2fs /dev/mmcblk0p3

# generate locale data
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen

# add normal user
useradd -s /bin/bash -m -k /etc/skel sipeed
echo 'sipeed:licheepi' | chpasswd
echo 'root:root' | chpasswd
usermod -a -G dialout sipeed
usermod -a -G cdrom sipeed
usermod -a -G sudo sipeed
usermod -a -G audio sipeed
usermod -a -G video sipeed
usermod -a -G plugdev sipeed
usermod -a -G users sipeed
usermod -a -G netdev sipeed

# change hostname
NEW_HOSTNAME="lpi4a-$(cat /sys/class/net/end0/address | tr -d ':\n' | tail -c 4)"
echo "NEW HOSTNAME: $NEW_HOSTNAME"
echo "$NEW_HOSTNAME" > /etc/hostname
echo "127.0.0.1	$NEW_HOSTNAME" > /etc/hosts
hostname "$NEW_HOSTNAME"
nmcli general hostname "$NEW_HOSTNAME"
cp /usr/share/doc/avahi-daemon/examples/sftp-ssh.service  /etc/avahi/services/
systemctl enable avahi-daemon

# regenerate openssh host keys
dpkg-reconfigure openssh-server

# chromium sandbox is not working
sed -i -e 's/\/usr\/bin\/chromium/\/usr\/bin\/chromium --no-sandbox/g' /usr/share/applications/chromium.desktop
sed -i -e 's/exo-open --launch WebBrowser/\/usr\/bin\/chromium --no-sandbox/g' /usr/share/applications/xfce4-web-browser.desktop

# rotate lightdm
sed -ie 's/#display-setup-script=/display-setup-script=\/opt\/display-setup.sh/g' /etc/lightdm/lightdm.conf

# default wallaper
ln -sf /usr/share/images/ruyisdk/ruyi-1-1920x1080.png /usr/share/images/desktop-base/desktop-background
ln -sf /usr/share/images/ruyisdk/ruyi-2-1920x1080.png /usr/share/images/desktop-base/login-background.svg

# avahi daemon
sed -i -e 's/publish-workstation=no/publish-workstation=yes/g' /etc/avahi/avahi-daemon.conf

# disable iperf3 service
systemctl disable iperf3
systemctl stop iperf3

# enable boot setup
systemctl enable boot-setup

# enable cst3240 userspace driver
if (cat /proc/device-tree/model | grep Z14INCH-M0);
then
	systemctl enable cst3240
else
	systemctl disable cst3240
fi

# reboot this machine after 60s
shutdown -r 1
