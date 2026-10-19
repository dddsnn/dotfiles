#!/bin/bash

export XDG_RUNTIME_DIR=$(mktemp -d --tmpdir xdg-runtime-dir-XXX)
exec ssh-agent dbus-run-session sway --unsupported-gpu
