#!/bin/bash

# Common functions used in sway management.

# Show notification with icon.
notify() {
    message="${1}"
    shift
    notify-send --icon ~/fiete.png $@ "Sway background" "${message}"
}

disable_internal_display_if_lid_closed() {
    if grep -q closed /proc/acpi/button/lid/LID/state ; then
        # If the lid is closed, disabled the internal display so kanshi can set
        # the correct config. Sleep to wait for the state to settle.
        (sleep 4 ; swaymsg output eDP-1 disable) &
    fi
}

connect_to_turbulens() {
    for ((try=1 ; try<11 ; try++)) ; do
        nmcli -f GENERAL.STATE connection show turbulens | grep -q activated
        if [ $? -eq 0 ] ; then
            notify "turbulens was already connected."
            return
        fi
        output=$(nmcli connection up turbulens 2>&1)
        if [ $? -eq 0 ] ; then
            notify "Connected to turbulens."
            return
        fi
        notify "Failed to connect to turbulens at try ${try}:\n${output}"
        sleep 1
    done
    notify "Failed to connect to turbulens after 10 tries:\n${output}" \
        --urgency critical
}
