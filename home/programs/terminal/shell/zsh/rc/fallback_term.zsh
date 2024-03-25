# If the set $TERM variable doesn't match any configured terminfo entries
# fall back to xterm. This fixes SSH connections from unknown terminals

if [ -z "$TERM" ]; then
  export TERM=xterm
elif ! infocmp "$TERM" &>/dev/null; then
  export TERM=xterm
  echo "TERM set to xterm due to missing terminfo entry."
end
