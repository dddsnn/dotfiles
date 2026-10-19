#!/bin/bash

brightness=$(cat /sys/class/backlight/amdgpu_bl1/brightness)
max_brightness=$(cat /sys/class/backlight/amdgpu_bl1/max_brightness)
brightness_percent=$((brightness * 100 / max_brightness))
batt_percent=$(cat /sys/class/power_supply/BAT0/capacity)
batt_status=$(cat /sys/class/power_supply/BAT0/status)
time=$(date --iso-8601=seconds)

echo "\
Brightness ${brightness_percent}% | \
Battery ${batt_percent}% ${batt_status} | \
${time}\
"
