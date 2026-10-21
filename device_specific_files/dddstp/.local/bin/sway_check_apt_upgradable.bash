#!/bin/bash

# Small script that checks and informs about upgradable packages.

source ~/.local/bin/sway_lib.bash

# Wait a minute until the startup is done.
# sleep 60

sudo apt update
if [ $? -ne 0 ] ; then
    notify "Error running apt update." --urgency critical
fi

num_upgradable=$(apt list --upgradable 2>/dev/null | wc -l)

if [ "${num_upgradable}" -ne 0 ] ; then
    notify "There are ${num_upgradable} upgradable packages." --urgency critical
fi
