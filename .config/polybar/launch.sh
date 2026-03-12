#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Export hwmon path if needed
export HWMON_PATH=$(find /sys/devices/platform/coretemp.0/hwmon -name temp1_input | head -n 1)

# Launch bars
polybar left -c ~/.config/polybar/config_pill.ini &
polybar stats -c ~/.config/polybar/config_pill.ini &
polybar weather -c ~/.config/polybar/config_pill.ini &
polybar center -c ~/.config/polybar/config_pill.ini &
polybar right -c ~/.config/polybar/config_pill.ini &
