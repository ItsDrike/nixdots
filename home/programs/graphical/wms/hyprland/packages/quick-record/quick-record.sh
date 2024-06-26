#!/bin/bash

EXTENSION="mp4"
NOTIFY=0

save_file() {
    wl-copy -t text/uri-list "file://${file}"
    [ "$NOTIFY" -eq 1 ] && notify-send -a "quick-record" "Recording saved" "$file <file://${file}>"
    echo "Recording saved: $file"
}

stop_recording() {
    if pidof -s wf-recorder >/dev/null 2>&1; then
        [ "$NOTIFY" -eq 1 ] && notify-send -a "quick-record" "Recording stopped"
        killall -s SIGINT wf-recorder
    else
        >&2 echo "No active recording to stop"
        return 1
    fi
}

start_recording() {
    # Remove all previous recordings
    # No need to clutter /tmp, since this is used for copying the recording
    # as a file, it's unlikely that we'll need any of the old recordings
    # when a new one is requested
    rm "${TMPDIR:-/tmp}"/wf-recorder-video-*."$EXTENSION" 2>/dev/null || true

    file="$(mktemp -t "wf-recorder-video-XXXXX.$EXTENSION")"
    geom="$(slurp)"

    [ "$NOTIFY" -eq 1 ] && notify-send "quick-record" "Recording starting"

    trap save_file SIGINT
    trap save_file SIGTERM
    trap save_file SIGHUP

    # Wee need 'y' stdin to confirm that we want to override the file
    # since mktemp creates a blank file there already
    # TODO: The -x 420p is a temporary fix to address the recordings appearing
    # corrupted in firefox/discord/... See: <https://github.com/ammen99/wf-recorder/issues/218>
    echo "y" | wf-recorder -g "$geom" -f "$file" -x yuv420p

    # If wf-recorder process ends directly, rather than a trap being hit
    # we also want to run the save_file func
    save_file
}

# Parse any CLI flags first, before getting to positional args
# (As long as we have $2, meaning there's at least 2 args, treat

# $1 arg as CLI flag``)
while [ "${2-}" ]; do
    case "$1" in
    -h | --help)
        cat <<EOF
quick-record is a simple tool for performing quick screen capture recordings
on wayland WMs easily, using wf-recorder.

Optional flags:
-n | --notify: Produce notifications on recording start/end
-e | --extension [extension]: Use a different file extension (default: mp4)

Required positional arguments:
{start|stop|toggle}: Action which to perform.
    - start: Start a new recording
    - stop: Stop any already running recording(s)
    - toggle: If there is a running recording, stop it, otherwise start a new one
EOF
        exit 0
        ;;
    -n | --notify)
        NOTIFY=1
        shift
        ;;
    -e | --extension)
        EXTENSION="$2"
        shift
        shift
        ;;
    esac
done

if [ "${1-}" = "start" ]; then
    start_recording
elif [ "${1-}" = "stop" ]; then
    stop_recording
elif [ "${1-}" = "toggle" ]; then
    if stop_recording 2>/dev/null; then
        exit 0
    else
        start_recording
    fi
else
    >&2 echo "Error: No argument provided!"
    >&2 echo "Expected one of: start, stop, toggle"
    exit 1
fi
