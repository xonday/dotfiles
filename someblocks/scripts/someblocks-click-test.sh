#!/usr/bin/env bash


# Output wrapper + command + text + close wrapper
# When clicked, this runs 'gnome-calendar'
echo "^lm(notify-send "test" -t 2000)test^lm()"
