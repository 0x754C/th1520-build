#!/bin/sh

cp -rv /etc/skel/.config /home/sipeed/
chown -R sipeed:sipeed /home/sipeed/
echo 'setup done'
