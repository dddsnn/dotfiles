#!/bin/bash

export XDG_RUNTIME_DIR=$(mktemp -d --tmpdir xdg-runtime-dir-XXX)
export XDG_CURRENT_DESKTOP=sway
exec ssh-agent dbus-run-session sway
