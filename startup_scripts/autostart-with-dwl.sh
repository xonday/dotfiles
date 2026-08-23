#!/bin/sh

# scale display
/usr/bin/wlr-randr --output eDP-1 --scale 1.5

# Set the wallpaper
/usr/bin/swaybg -i /home/alex/Tech/dotfiles/images/fancy_setup_2560x1600.png &
#/usr/bin/swaybg -i /home/alex/Pictures/fallFoliage.jpeg &

# Start mako (notification daemon)
/usr/bin/mako &

# start cliphist
wl-paste --watch cliphist store &

/usr/local/bin/dwlb -ipc -scale 2 #-font "Nerd Font Mono=12" -scale 2
#dwlb -ipc -font "DejaVu Sans Mono=13" # -scale 2
#dwlb -ipc -font "Adwaita Sans=13" # -scale 2

