# Foot terminal uses this sequence to identify a command execution
# that way it's possible to use ctrl+shift+z/x to jump between commands
if [ "$TERM" = "foot" ]; then
    precmd() {
        print -Pn "\e]133;A\e\\"
    }
fi
