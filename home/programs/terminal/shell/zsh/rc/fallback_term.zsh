# If the set $TERM variable doesn't match any configured terminfo entries
# fall back to xterm. This fixes SSH connections from unknown terminals

if ! infocmp "$TERM" &>/dev/null; then
  local original="$TERM"
  export TERM=xterm-256color
  echo "TERM set to $TERM due to missing terminfo entry for $original."
fi
