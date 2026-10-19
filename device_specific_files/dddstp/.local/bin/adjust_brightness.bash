#!/bin/bash

shopt -s extglob

BRIGHTNESS_FILE=/sys/class/backlight/amdgpu_bl1/brightness

current_brightness=$(cat ${BRIGHTNESS_FILE})
max_brightness=$(cat /sys/class/backlight/amdgpu_bl1/max_brightness)

add=0
case $1 in
    ++([0-9])\%)
        add=${1:1:-1}
        ;;
    -+([0-9])\%)
        add=-${1:1:-1}
        ;;
    *)
        echo "invalid, must be +<n>% or -<n>%"
        exit 1
        ;;
esac

current_percent=$(((current_brightness * 100) / max_brightness))
new_percent=$((current_percent + add))
new_brightness=$(((max_brightness * new_percent) / 100))
new_brightness=$((new_brightness > 0 ? new_brightness : 0))
new_brightness=$((new_brightness < max_brightness ? new_brightness : max_brightness))
echo ${new_brightness} > ${BRIGHTNESS_FILE}

exit 0
