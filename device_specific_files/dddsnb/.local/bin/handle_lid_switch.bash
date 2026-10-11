#!/bin/bash

status=$1
if [[ -z ${SWAYSOCK+x} ]] ; then
    echo "SWAYSOCK is not set"
    exit 1
fi

if [[ ${status} = "on" ]] ; then
    # Lid closed, shut off internal display.
    sway output eDP-1 disable > /dev/null
elif [[ ${status} = "off" ]] ; then
    # Lid opened, power on again.
    sway output eDP-1 enable > /dev/null
else
    echo "Invalid status, must be on or off."
    exit 1
fi

outputs=$(swaymsg -r -t get_outputs)
num_outputs=$(echo ${outputs} | jq '. | length')
active_ouputs=""
inactive_ouputs=""
for i in $(seq 0 $((num_outputs - 1))) ; do
    output=$(echo ${outputs} | jq --arg i ${i} '.[$i | tonumber]')
    output_name=$(echo ${output} | jq '.name')
    if [ "$(echo ${output} | jq '.active')" = "true" ] ; then
        active_ouputs="${active_ouputs} ${output_name}"
    else
        inactive_ouputs="${inactive_ouputs} ${output_name}"
    fi
done

if [[ ${status} = "on" ]] ; then
    if [[ ${active_ouputs} = "" ]] ; then
        # Lid is closed, no active outputs.
        echo mem > /sys/power/state
    fi
fi
