#!/bin/sh
# kill leftover someblocks from a previous session
pkill someblocks
exec dwl -s "$HOME/.local/bin/autostart-with-dwl.sh"
