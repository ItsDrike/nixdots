#!/usr/bin/env bash

BAT=$(echo /sys/class/power_supply/BAT*) # only supports single-battery systems
BAT_STATUS="$BAT/status"
BAT_CAP="$BAT/capacity"

POWER_SAVE_PERCENT=50 # Enter power-save mode if on bat and below this capacity

HAS_PERFORMANCE="$(powerprofilesctl list | grep "performance" || true)" # the || true ignores grep failing with non-zero code

# monitor loop
prev=0
while true; do
	# read the current state
	status="$(cat "$BAT_STATUS")"
	capacity="$(cat "$BAT_CAP")"

	if [[ $status == "Discharging" ]]; then
		if [[ $capacity -le $POWER_SAVE_PERCENT ]]; then
			profile="power-saver"
		else
			profile="balanced"
		fi
	else
		if [[ -n $HAS_PERFORMANCE ]]; then
			profile="performance"
		else
			profile="balanced"
		fi
	fi

	# Set the new profile
	if [[ $profile != $prev ]]; then
		echo -en "Setting power profile to ${profile}\n"
		powerprofilesctl set $profile
		prev=$profile
	fi

	# wait for changes in status or capacity files
	# i.e. for the next power change event
	inotifywait -qq "$BAT_STATUS" "$BAT_CAP"
done
