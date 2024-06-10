#!/bin/sh
# This is mainly a wrapper, acting as just: `brightnessctl s $1`
# However, in addition, this will also produce a notification with
# the brightness level shown as a progress bar.

# Send brightness level desktop notification, showing the given brightness level
# as progress bar, along with given message.
# $1 - brightness level (number 0-100)
send_brightness_notify() {
	percent_brightness="$1"

	notify-send \
		--app-name="brightness" \
		--urgency="normal" \
		-h int:value:$percent_brightness \
		-h string:synchronous:brightness \
		"brightness" "Level: $percent_brightness"
}

out="$(brightnessctl s "$1")"
cur_percent="$(echo "$out" | grep "Current" | grep -oP '\(\d+%' | tr -d '()%')"
send_brightness_notify "$cur_percent"
