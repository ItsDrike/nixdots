#!/usr/bin/env bash

# Parse arguments
# ------------------------------------------------------------------------------------
ALL=0
VERBOSE=0
VERY_VERBOSE=0
VERY_VERY_VERBOSE=0
TEMP_SHOW=0
DRY_RUN=0
NO_CACHE=0
NO_DISPLAY=0
MAX_AMOUNT=0
URGENCY="normal"
RESET=0
while [ "${1-}" ]; do
  case "$1" in
  -h | --help)
    cat <<EOF
gh-notification is a tool that scrapes unread github notifications
It uses github-cli with meiji163/gh-notify addon to obtain the unread notifications
these are then parsed and sent as desktop notifications with notify-send
(gh extension install meiji163/gh-notify)

Options:
-a | --all: Also process already read notifications
-t | --temp-files: Show names of used temporary files for each notification
-v | --verbose: Shows info about what's happening.
-vv | --very-verbose: Implies --verbose, shows some more info about what's happening
-vvv | --very-very-verbose: Implies --very-verbose and --temp-files, shows even more details, usually just for debugging
-d | --dry-run: Run without sending any notificatinos, when ran with -r, this will also prevent any actual cache file removals
-nc | --no-cache: Ignore the cache and send all found notifications, even if they were already sent before.
-nd | --no-display: When the script is ran from headless mode (such as by crontab), this will still attempt to set the DISPLAY and send the desktop notification
-r | --reset: Resets notification cache (storing which notifications were already sent), skips notification sending, WARNING: removes the whole cache, regardless of '--all')
-u | --urgency [urgency-level]: pass over notify-send urgency attribute (low, normal, critical)
-n | --number [amount]: maximum amount of notifications to show
EOF
    exit 0
    ;;
  -a | --all)
    ALL=1
    ;;
  -t | --temp-files)
    TEMP_SHOW=1
    ;;
  -v | --verbose)
    VERBOSE=1
    ;;
  -vv | --very-verbose)
    VERBOSE=1
    VERY_VERBOSE=1
    ;;
  -vvv | --very-very-verbose)
    VERBOSE=1
    TEMP_SHOW=1
    VERY_VERBOSE=1
    VERY_VERY_VERBOSE=1
    ;;
  -d | --dry-run)
    DRY_RUN=1
    ;;
  -nc | --no-cache)
    NO_CACHE=1
    ;;
  -nd | --no-display)
    NO_DISPLAY=1
    ;;
  -u | --urgency)
    URGENCY="$2"
    shift
    ;;
  -n | --number)
    MAX_AMOUNT="$2"
    shift
    ;;
  -r | --reset)
    RESET=1
    ;;
  *)
    echo "Unknown argument '$1', use -h or --help for help"
    exit 1
    ;;
  esac
  shift
done

# Perform cache resetting, if requested
# ------------------------------------------------------------------------------------
if [ $RESET -eq 1 ]; then
  if [ $NO_CACHE -eq 1 ]; then
    echo "Can't ignore cache when resetting the cache..."
    exit 1
  fi
  out="$(find /tmp -maxdepth 1 -name 'gh-notification-*' 2>/dev/null)"
  total="$(printf "%s\n" "$out" | wc -l)"
  # Since we always end with a newline (to count the last entry as a line), we always get
  # at least 1 as a total here, even if $out is empty. If we didn't use the \n, we'd always
  # get 0, even if there was a single line, since it wasn't ended with a newline. To figure
  # out whether there really is a line or not when we get a total of 1, we run character
  # amount check as well
  [ "$total" -eq 1 ] && [ "$(printf "%s" "$out" | wc -c)" -eq 0 ] && total=0

  if [ "$total" -gt 0 ]; then
    # Since the loop is running in a pipe, it can't modify variables, but we need to know
    # which files have failed to be removed, so to get that information, we store it in a
    # teporary file
    fail_files_file="$(mktemp)"

    printf "%s\n" "$out" | while read -r file_name; do
      # If desired, let user know about the found notification cache file
      if [ $VERY_VERBOSE -eq 1 ] || [ $TEMP_SHOW -eq 1 ]; then
        contents="$(cat "$file_name")"
        title="$(printf "%s" "$contents" | awk -F '~@~' '{ print $1 }')"

        echo "Found cache tempfile: '$file_name' - $title"
        if [ $VERY_VERY_VERBOSE -eq 1 ]; then
          description="$(printf "%s" "$contents" | awk -F '~@~' '{ print $2 }')"
          echo "Notification description: $description"
        fi
      fi

      if [ $DRY_RUN -ne 1 ]; then
        # In case `rm` fails, keep track of which files it failed on
        if ! rm "$file_name" 2>/dev/null; then
          printf "%s\n" "$file_name" >>"$fail_files_file"
        fi
      else
        [ $VERY_VERY_VERBOSE -eq 1 ] && echo "Tempfile removal skipped (dry-run)"
      fi

      # Add a new-line separator on very very verbose to group prints from each iteration
      [ $VERY_VERY_VERBOSE -eq 1 ] && echo ""
    done

    # Recover failed files from the temporary file
    failed_files="$(cat "$fail_files_file")"
    failed="$(printf "%s" "$fail_files_file" | wc -l)"
    rm "$fail_files_file"

    if [ $VERBOSE -eq 1 ]; then
      echo "Notification cache was reset."
      removed_count="$(("$total" - "$failed"))"
      if [ $DRY_RUN -eq 1 ]; then
        echo "Removed $removed_count files (dry-run: no files were actually removed)"
      else
        echo "Removed $removed_count files"
      fi
    fi

    # If some cache files were'nt removed successfully, inform the user about it
    # regardless of verbosity, this shouldn't go silent, even though it may be fine
    if [ "$failed" -gt 0 ]; then
      echo "WARNING: Failed to remove $failed files."
      echo "You probably don't have permission to remove these."
      echo "Perhaps these were made by someone else? If so, you can ignore this warning."
      if [ $VERBOSE -eq 0 ]; then
        echo "Run with --verbose to show exactly which files weren't removed."
      else
        echo "These are:"
        echo "$failed_files"
      fi
    fi
  else
    [ $VERBOSE -eq 1 ] && echo "No cache files found, nothing to reset"
  fi
  exit 0
fi

# Helper functins
# ------------------------------------------------------------------------------------
# This runs notify-send, and if NO_DISPLAY is set and we're running in headless
# mode, this will still try to send the notification by manually setting DISPLAY
# This also has a special handle that checks if dunst is the notification daemon
# in which case instead of using notify-send, we use dunstify to send the
# notification, with which we can also specify some more values.
send_notify() {
  if [ $NO_DISPLAY -eq 1 ]; then
    XDG_RUNTIME_DIR="/run/user/$(id -u)" \
    DISPLAY=:0 \
      notify-send -i "$HOME/.local/share/icons/hicolor/64x64/apps/github-notification.png" --app-name=github-notification --urgency="$URGENCY" "$1" "$2"
  else
    notify-send -i "$HOME/.local/share/icons/hicolor/64x64/apps/github-notification.png" --app-name=github-notification --urgency="$URGENCY" "$1" "$2"
  fi
}

# Obtain notifications and show them, if they weren't showed (aren't in cache) already
# ------------------------------------------------------------------------------------
# Request unread notifications with gh-notify extension for github-cli
[ $VERY_VERBOSE -eq 1 ] && echo "Requesting notifications..."
[ "$ALL" -eq 1 ] && out="$(gh notify -s -a -n "$MAX_AMOUNT" 2>/dev/null)" || out="$(gh notify -s -n "$MAX_AMOUNT" 2>/dev/null)"
[ $VERY_VERBOSE -eq 1 ] && echo "Notifications received"

# When no notifications were found, set output to empty string, to avoid 'All caught up!' line
# being treated as notification
if [ "$out" == "All caught up!" ]; then
  out=""
fi

total="$(printf "%s\n" "$out" | wc -l)"
# Since we always end with a newline (to count the last entry as a line), we always get
# at least 1 as a total here, even if $out is empty. If we didn't use the \n, we'd always
# get 0, even if there was a single line, since it wasn't ended with a newline. To figure
# out whether there really is a line or not when we get a total of 1, we run character
# amount check as well
[ "$total" -eq 1 ] && [ "$(printf "%s" "$out" | wc -c)" -eq 0 ] && total=0

# Only run if we actually found some notifications
if [ "$total" -gt 0 ]; then
  # Since the loop is running in a pipe, it can't modify variables, but we need to know
  # how many notifications were sent, so to ge that information, we store it in a
  # temporary file
  sent_count_file="$(mktemp)"
  printf "0" >"$sent_count_file"

  # Go through each notification, one by one
  printf "%s\n" "$out" | while read -r line; do

    [ $VERY_VERY_VERBOSE -eq 1 ] && echo "gh-notify output line: $line"

    # Parse out the data from given output lines
    issue_type="$(echo "$line" | awk -F '  +' '{print $4}' | sed 's/\x1b\[[0-9;]*m//g')"
    repo_id="$(echo "$line" | awk -F '  +' '{print $3}' | sed 's/\x1b\[[0-9;]*m//g')"

    if [ "$issue_type" == "PullRequest" ]; then
      issue_id="$(echo "$line" | awk -F '  +' '{print $5}' | sed 's/\x1b\[[0-9;]*m//g' | cut -c2-)"
      description="$(echo "$line" | awk -F '  +' '{for (i=6; i<NF; i++) printf $i " "; print $NF}' | sed 's/\x1b\[[0-9;]*m//g')"
      name="$repo_id ($issue_type #$issue_id)"

      url="https://github.com/$repo_id/pull/$issue_id"
    elif [ "$issue_type" == "Issue" ]; then
      issue_id="$(echo "$line" | awk -F '  +' '{print $5}' | sed 's/\x1b\[[0-9;]*m//g' | cut -c2-)"
      description="$(echo "$line" | awk -F '  +' '{for (i=6; i<NF; i++) printf $i " "; print $NF}' | sed 's/\x1b\[[0-9;]*m//g')"
      name="$repo_id ($issue_type #$issue_id)"

      url="https://github.com/$repo_id/issues/$issue_id"
    elif [ "$issue_type" == "Release" ]; then
      # There's no issue ID with github releases, they just have a title
      # this means if the name is the same, they will be treated as the same release
      # and they could end up being ignored, this could be fixed by using github API and
      # searching for that release's commit, but that's too much work here for little benefit
      description="$(echo "$line" | awk -F '  +' '{for (i=5; i<NF; i++) printf $i " "; print $NF}' | sed 's/\x1b\[[0-9;]*m//g')"
      name="$repo_id ($issue_type)"

      # Because we don't know the tag or commit ID, best we can do is use the page for all releases
      # the new release will be the first one there anyway
      url="https://github.com/$repo_id/releases"
    elif [ "$issue_type" == "Commit" ]; then
      description="$(echo "$line" | awk -F '  +' '{for (i=5; i<NF; i++) printf $i " "; print $NF}' | sed 's/\x1b\[[0-9;]*m//g')"
      name="$repo_id ($issue_type)"

      # Because we don't know the commit SHA, just go to the repo itself
      url="https://github.com/$repo_id"
    elif [ "$issue_type" == "Discussion" ]; then
      description="$(echo "$line" | awk -F '  +' '{for (i=5; i<NF; i++) printf $i " "; print $NF}' | sed 's/\x1b\[[0-9;]*m//g')"
      name="$repo_id ($issue_type)"

      # Annoyingly, the discussion ID isn't included here, so best we can do is go to the discussions section
      url="https://github.com/$repo_id/discussions"
    elif [ "$issue_type" == "RepositoryDependabotAlertsThread" ]; then
      description="$(echo "$line" | awk -F '  +' '{for (i=5; i<NF; i++) printf $i " "; print $NF}' | sed 's/\x1b\[[0-9;]*m//g')"
      name="$repo_id ($issue_type)"

      # The specific dependabot notification id isn't included, so this just goes to all security warnings for the repo
      url="https://github.com/$repo_id/security/dependabot"
    else
      echo "Unknown issue type: '$issue_type'!"
      echo "Can't construct URL, falling back to just repository URL."
      echo "Please report this issue to ItsDrike/dotfiles repository."
      url="https://github.com/$repo_id"
    fi

    [ $VERY_VERBOSE -eq 1 ] && echo "Found notification $name"
    [ $VERY_VERY_VERBOSE -eq 1 ] && echo "Description: $description"
    [ $VERY_VERY_VERBOSE -eq 1 ] && echo "Constructed url: $url"

    # Create hash from the name and description and use it to construct
    # a path to a temporary file
    # To keep this POSIX compliant, we can't use <<< to feed a string to the
    # sum function, so we're using another temporary file which is then removed
    temp_file="$(mktemp)"
    printf "%s%s" "$name" "$description" >"$temp_file"
    hashsum="$(sum <"$temp_file" | cut -f 1 -d ' ')"
    rm "$temp_file"

    tmpname="/tmp/gh-notification-$hashsum"
    [ $TEMP_SHOW -eq 1 ] && echo "Tempfile: $tmpname"

    # If the temporary file is already present, this notification was already
    # send and we don't want to re-send it

    # Only sent the notification if it wasn't already cached (doesn't have temp file)
    # this avoids resending the same notifications
    if [ ! -e "$tmpname" ] || [ $NO_CACHE -eq 1 ]; then
      if [ $DRY_RUN -eq 1 ]; then
        [ $VERY_VERBOSE -eq 1 ] && echo "Sending notification (dry-run, no actual notification was sent)"
      else
        [ $VERY_VERBOSE -eq 1 ] && echo "Sending notification"
        send_notify "$name" "$description <$url>"
        # Create the tempfile so that in the next run, we won't resend this notification again
        # NOTE: We're storing the name and description into this file to make it easier
        # to figure out what notification the tempfile belongs to, with ~@~ separator
        printf "%s~@~%s" "$name" "$description" >"$tmpname"
      fi
      # Keep track of how many notifications were sent (didn't have a cache file)
      sent="$(cat "$sent_count_file")"
      sent="$(("$sent" + 1))"
      printf "%s" "$sent" >"$sent_count_file"
    else
      [ $VERY_VERBOSE -eq 1 ] && echo "Skipping (cached) - notification already sent"
    fi

    # Add a new-line separator on very verbose to group prints from each iteration
    [ $VERY_VERBOSE -eq 1 ] && echo ""
  done || true

  # Recover amount of sent notifications from the temporary file
  sent="$(cat "$sent_count_file")"
  rm "$sent_count_file"

  if [ $VERBOSE -eq 1 ]; then
    unsent="$(("$total" - "$sent"))"
    if [ "$sent" -eq "$total" ]; then
      echo "Found and sent $total new notifications"
    elif [ "$unsent" -eq "$total" ]; then
      echo "Found $total notifications, all of which were already sent (no new notifications to send)"
    else
      echo "Found $total notifications, of which $sent were new and sent ($unsent were skipped - cached/already sent)"
    fi
  fi
else
  [ $VERBOSE -eq 1 ] && echo "No new notifications"
fi
