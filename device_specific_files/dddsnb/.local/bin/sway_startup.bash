#!/bin/bash

# Helper script executing stuff that needs to be done once sway has started.

source ~/.local/bin/sway_lib.bash

# Get the unique sway container ID for a window's app_id.
con_id_by_app_id() {
    local app_id="${1}"
    local jq_cmd='.. | objects | select(.app_id? == $app_id) | .id'
    swaymsg -t get_tree -r | jq --arg app_id "${app_id}" "${jq_cmd}"
}

# Wait for an app with the given app_id to appear in the sway tree.
wait_for_app_id() {
    local app_id="${1}"
    local timeout="${2:-60}"
    local started=${SECONDS}

	while [ "$(con_id_by_app_id ${app_id})" = "" ] ; do
        if (( SECONDS - started >= timeout )); then
            notify \
                "Waited ${timeout}s for ${app_id}, but it hasn't started up." \
                --urgency critical
            return 1
        fi
        sleep 0.1
    done
}

set_internal_display_state

# Start keepassxc on workspace 7 (there's a weird bug where it's always fullscreen).
sway 'workspace number 7; exec keepassxc &'
wait_for_app_id org.keepassxc.KeePassXC
keepassxc=$(con_id_by_app_id org.keepassxc.KeePassXC)
sway "[con_id=${keepassxc}] move to workspace 7"

notify "Waiting for secret service to become available..."
while true ; do
    # Check the special marker entry in keepassxc that tells us the secret
    # service is available. This essentailly waits until keepassxc is unlocked.
    output=$(secret-tool lookup secret-service-running true 2>&1)
    if [ $? -eq 0 ] ; then
        notify "Secret service is available."
        break
    fi
    notify "Waiting for secret service to become available...\n\n ${output}"
    sleep 1
done

# Start thunderbird on workspace 1.
sway 'workspace number 1 ; exec thunderbird &'
wait_for_app_id thunderbird-esr
thunderbird=$(con_id_by_app_id thunderbird-esr)
# Move it up so it's on top. Not sure why, but we have to move up twice.
sway "[con_id=${thunderbird}] focus ; move up ; move up"
# Set thunderbird to split its row into columns.
sway "[con_id=${thunderbird}] focus ; splith"
sway "[con_id=${thunderbird}] resize set height 80 ppt"

notify "Workspace 1 set up."

# Now start firefox and zed because we'll probably need them. They'll go to
# their default workspaces.
exec firefox &
exec zedit &
wait_for_app_id firefox-esr
wait_for_app_id dev.zed.Zed

notify "Startup complete."
