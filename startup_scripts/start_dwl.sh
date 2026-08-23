#!/bin/sh
# dwl -s allows one to pass commands to dwl
#slstatus -s | dwl -s "sh -c 'swaybg -i ./images/berserk_guts_2560x1600.png &'"
#slstatus -s | dwl -s "sh -c 'swaybg -i ./images/fancy_setup_2560x1600.png &' && ./dotfiles/display-niceties.sh"

# kill any running someblocks instance (would otherwise happen when restarting a dwl session)
/usr/bin/pkill someblocks

#exec dbus-launch --exit-with-session dwl -s ./autostart-with-dwl.sh & sleep 0.1 && someblocks -p |dwlb -status-stdin all &

# exec dwl with "autostart" script as start command; sleep 0.1 for dwlb to start and be able to receive someblocks stdout
/usr/local/bin/dwl -s ./autostart-with-dwl.sh & /usr/bin/sleep 0.1 && /usr/local/bin/someblocks -p | /usr/local/bin/dwlb -status-stdin all &

