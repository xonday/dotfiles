#!/bin/sh
#echo -ne "$(cat /sys/class/power_supply/BAT0/capacity)%"
#printf "%s%%" "$(cat /sys/class/power_supply/BAT0/capacity)"
cat /sys/class/power_supply/BAT0/capacity
