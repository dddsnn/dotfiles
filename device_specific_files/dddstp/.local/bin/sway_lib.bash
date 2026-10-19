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
    if nmcli -f GENERAL.STATE connection show turbulens | grep -q activated ; then
        notify "turbulens was already connected."
    elif nmcli connection up turbulens 2>&1 > /dev/null ; then
        notify "Connected to turbulens."
    else
        notify "Failed to connect to turbulens." --urgency critical
    fi
}
