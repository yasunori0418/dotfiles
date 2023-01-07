#!/usr/bin/env bash

xrandr --output eDP --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-A-0 --primary --mode 1920x1080 --pos 1920x0 --rotate normal
wallpaper=~/Pictures/wallpaper/Nordic-darker.png
feh --bg-fill $wallpaper $wallpaper
