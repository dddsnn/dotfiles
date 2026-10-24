#!/bin/bash

# Subscribe to sway output events to see if we have to disable the internal
# display.

source ~/.local/bin/sway_lib.bash

while true ; do
    # This will return a json on every change to outputs.
    change=$(swaymsg -t subscribe '["output"]' | jq '.change')
    echo "Got change ${change}, checking if we need to disable the display."
    set_internal_display_state 1
    sleep 1
done
