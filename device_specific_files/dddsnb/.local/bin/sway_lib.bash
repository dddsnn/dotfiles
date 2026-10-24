#!/bin/bash

# Common functions used in sway management.

# Show notification with icon.
notify() {
    message="${1}"
    shift
    notify-send --icon ~/fiete.png $@ "Sway background" "${message}"
}

set_internal_display_state() {
    timeout=${1:-4}
    if grep -q closed /proc/acpi/button/lid/LID0/state ; then
        # If the lid is closed, disabled the internal display so kanshi can set
        # the correct config. Sleep to wait for the state to settle.
        (sleep "${timeout}" ; swaymsg output eDP-1 disable) &
    else
        # If the lid is open, enable the internal display, but only if it isn't
        # already.
        jq_cmd='.[] | select(.name == "eDP-1").active'
        state=$(swaymsg -r -t get_outputs | jq "${jq_cmd}")
        if [ "${state}" != "true" ] ; then
            (sleep "${timeout}" ; swaymsg output eDP-1 enable) &
        fi
    fi
}
