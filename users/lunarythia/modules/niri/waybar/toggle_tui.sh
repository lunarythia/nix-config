#!/usr/bin/env bash

APP="$1"
TERM="kitty"
TERM_ARGS="-o confirm_os_window_close=0"
CLASS="${TERM}_waybar_${APP}"

if [ "$XDG_CURRENT_DESKTOP" = "niri" ]; then
    niri msg windows | grep -q "App ID: \"$CLASS\"" && pkill -f "\-\-class=$CLASS" && exit 0
elif [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
    hyprctl clients | grep -q "class: $CLASS" && hyprctl dispatch "hl.dsp.window.close({ window = 'class:$CLASS' })" && exit 0
fi

$TERM --class="$CLASS" $TERM_ARGS $APP &
