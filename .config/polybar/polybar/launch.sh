#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# while [ $(xrandr --query | grep " connected" | wc -l) -ne 2 ]; do
#     notify-send "Waiting for monitors..."
#     sleep 1
# done

# Launch bar1 and bar2
polybar main &
polybar secondary &
