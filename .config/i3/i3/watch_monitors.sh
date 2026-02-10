#!/bin/bash

xrandr --query | grep ' connected' | cut -d' ' -f1 | while read line; do
    echo $line
done

while inotifywait -e modify /sys/class/drm/*/status; do
    $HOME/.config/polybar/launch.sh
done
