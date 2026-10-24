#!/bin/bash

source ~/.local/bin/sway_lib.bash

if [[ -z ${SWAYSOCK+x} ]] ; then
    notify "SWAYSOCK is not set"
    exit 1
fi

set_internal_display_state 0.25

outputs=$(swaymsg -r -t get_outputs)
num_outputs=$(echo ${outputs} | jq '. | length')
active_ouputs=""
for i in $(seq 0 $((num_outputs - 1))) ; do
    output=$(echo ${outputs} | jq --arg i ${i} '.[$i | tonumber]')
    output_name=$(echo ${output} | jq '.name')
    if [ "$(echo ${output} | jq '.active')" = "true" ] ; then
        active_ouputs="${active_ouputs} ${output_name}"
    fi
done

if [[ "${active_ouputs}" = "" ]] ; then
    # Lid is closed, no active outputs. Go to sleep.
    # This requires sudo with no passwod for tee /sys/power/state.
    echo mem | sudo tee /sys/power/state
fi
