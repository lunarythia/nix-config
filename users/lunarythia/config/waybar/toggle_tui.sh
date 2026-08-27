#!/usr/bin/env bash

APP="$1"
TERM="kitty"
TERM_ARGS="-o confirm_os_window_close=0"
CLASS="${TERM}_waybar_${APP}"

if hyprctl clients | grep -q "class: $CLASS" ; then
    hyprctl dispatch "hl.dsp.window.close({ window = 'class:$CLASS' })"
else
    $TERM --class="$CLASS" $TERM_ARGS $APP &
fi
