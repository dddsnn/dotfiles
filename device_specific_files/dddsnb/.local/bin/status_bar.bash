#!/bin/bash

brightness=$(cat /sys/class/backlight/amdgpu_bl0/brightness)
max_brightness=$(cat /sys/class/backlight/amdgpu_bl0/max_brightness)
brightness_percent=$((brightness * 100 / max_brightness))
batt_percent=$(cat /sys/class/power_supply/BAT1/capacity)
batt_status=$(cat /sys/class/power_supply/BAT1/status)
time=$(date --iso-8601=seconds)

echo "\
Brightness ${brightness_percent}% | \
Battery ${batt_percent}% ${batt_status} | \
${time}\
"
