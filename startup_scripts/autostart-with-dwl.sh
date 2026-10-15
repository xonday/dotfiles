#!/bin/sh

# scale display
/usr/bin/wlr-randr --output eDP-1 --scale 1.5

# wallpaper
swaybg -i "$HOME/Tech/dotfiles/images/dayou-lu_wind-through-the-lotus-pond.JPG" &

# start notification daemon
/usr/bin/mako &

# start clipboard history
wl-paste --watch cliphist store &

# feed someblocks into the bar once dwlb is up
(sleep 1; someblocks -p | dwlb -status-stdin all) &

exec dwlb -ipc -scale 2
