#!/bin/bash

# thank ice

if [ -z "$DISPLAY" ]
then
	export DSIPLAY=:0.0
fi

xinput_dev="pointer:Goodix Capacitive TouchScreen"

if [ ! -d "/sys/class/drm/card0-DSI-1" ]; then
    xrandr --output HDMI-1 --auto --primary
    #echo off > /sys/class/drm/card0-DSI-1/status
else
    HDMI_STATUS="$(cat /sys/class/drm/card0-HDMI-A-1/status)"
    if [ "${HDMI_STATUS}" = "disconnected" ]; then
        xrandr --output DSI-1 --auto --rotate right --primary
        xinput map-to-output "$xinput_dev" DSI-1
    elif [ "${HDMI_STATUS}" = "connected" ]; then
        xrandr --output HDMI-1 --auto --primary
        xrandr --output DSI-1 --auto --rotate right --below HDMI-1
        xinput map-to-output "$xinput_dev" DSI-1
    fi
fi

