#!/bin/bash
hyprctl activewindow | grep "$2: $3"
if [[ $? -eq 0 ]]; then
    hyprctl dispatch sendshortcut $1, $2:$3
else
    hyprctl dispatch focuswindow $2:$3
    hyprctl dispatch sendshortcut $1, $2:$3
    hyprctl dispatch focuscurrentorlast
fi
