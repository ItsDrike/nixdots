#!/usr/bin/env bash

#ACTIVE_BORDER_COLOR="0xFF327BD1"
ACTIVE_BORDER_COLOR="0xFFFF6600"
DEFAULT_BORDER_COLOR="0xFFFFA500"

hyprctl dispatch fakefullscreen ""

fullscreen_status="$(hyprctl activewindow -j | jq '.fakeFullscreen')"
if [ "$fullscreen_status" = "null" ]; then
  echo "Update your hyprland, 'fakeFullscreen' window property not found."
  exit 1
elif [ "$fullscreen_status" = "true" ]; then
  window_address="$(hyprctl activewindow -j | jq -r '.address')"
  hyprctl setprop "address:$window_address" activebordercolor "$ACTIVE_BORDER_COLOR" lock
elif [ "$fullscreen_status" = "false" ]; then
  window_address="$(hyprctl activewindow -j | jq -r '.address')"
  hyprctl setprop "address:$window_address" activebordercolor "$DEFAULT_BORDER_COLOR"
else
  echo "Unexpected output from 'fakeFullscreen' window property: $fullscreen_status"
  exit 1
fi
