# User .profile definition.
# This file is only sourced once, after login, Unlike
# .zshrc/.bashrc, which will run whenever a new terminal is opened.

# Add all folders in ~/.local/bin into PATH
# Some window managers require this line to be in profile
# not in .zshenv
if [ -d "$HOME/.local/bin" ]; then
    PATH+=":${$(find -L ~/.local/bin -type d | tr '\n' ':')%%:}"
fi

# I'm using a greeter now, so the below is disabled.
# Start graphical session automatically on tty1 if Hyprland or startx is available
#if [ "$(tty)" = "/dev/tty1" ] && [ "$UID" != 0 ]; then
#    if command -v Hyprland >/dev/null; then
#      ! pidof -s Hyprland >/dev/null 2>&1 && Hyprland
#    elif command -v startx >/dev/null; then
#      ! pidof -s Xorg >/dev/null 2>&1 && exec startx "$XINITRC"
#    fi
#fi
