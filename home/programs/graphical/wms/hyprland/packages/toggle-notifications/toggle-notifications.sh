#!/bin/sh

if [ "$(dunstctl is-paused)" = "false" ]; then
  notify-send "Notifications" "Pausing notifications..." -h string:x-canonical-private-synchronous:notif-pause
  sleep 2
  dunstctl set-paused true
else
  dunstctl set-paused false
  notify-send "Notifications" "Notifications enabled" -h string:x-canonical-private-synchronous:notif-pause
fi
