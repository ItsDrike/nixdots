# Set or unset various zsh options.
# You can read more about what options are available and what these do in
# the ZSH manual: <https://zsh.sourceforge.io/Doc/Release/Options.html>
#
# Some of these are also controllable through nix configuration, however
# not all of them are, and I find it cleaner to have all of these groupped
# together in a single file, even if there are nix options for some of these
# I'm instead setting them manually here.

#########################
# General/Other options #
#########################

setopt AUTO_CD              # cd by typing directory name if it's not a command
setopt AUTO_LIST            # automatically list choices on ambiguous completion
setopt AUTO_MENU            # automatically use menu completion
setopt MENU_COMPLETE        # insert first match immediately on ambiguous completion
setopt AUTO_PARAM_SLASH     # if a parameter is completed with a directory, add trailing slash instead of space
setopt ALWAYS_TO_END        # move cursor to end if word had one match
setopt INTERACTIVE_COMMENTS # allow comments in interactive mode
setopt MAGIC_EQUAL_SUBST    # enable filename expansion for arguments of form `x=expression`
setopt NOTIFY               # report the status of background jobs immediately
setopt NUMERIC_GLOB_SORT    # sort filenames numerically when it makes sense
setopt GLOB_DOTS            # Match files starting with . without specifying it (cd <TAB>)


######################
# Auto pushd options #
######################

setopt AUTO_PUSHD           # Make cd push the old directory onto the directory stack
setopt PUSHD_IGNORE_DUPS    # don't push multiple copies of the same directory
setopt PUSHD_TO_HOME        # have pushd with no arguments act like `pushd $HOME`
setopt PUSHD_SILENT         # do not print the directory stack


#########################
# History Configuration #
#########################

# Append history list to history file once the session exits, rather than replacing
# the history file, erasing any past entries
setopt APPEND_HISTORY

# If the internal history needs to be trimmed to add the current command line, setting this
# option will cause the oldest history event that has a duplicate to be lost before losing a
# unique event from the list. You should be sure to set the value of HISTSIZE to a larger
# number than SAVEHIST in order to give you some room for the duplicated events, otherwise
# this option will behave just like HIST_IGNORE_ALL_DUPS once the history fills up with unique
# events.
setopt HIST_EXPIRE_DUPS_FIRST

# When searching for history entries in the line editor, do not display duplicates of a line
# previously found, even if the duplicates are not contiguous.
setopt HIST_FIND_NO_DUPS

# If a new command line being added to the history list duplicates an older one, the older
# command is removed from the list (even if it is not the previous event).
setopt HIST_IGNORE_ALL_DUPS

# Remove command lines from the history list when the first character on the line is a space,
# or when one of the expanded aliases contains a leading space. Only normal aliases (not
# global or suffix aliases) have this behaviour. Note that the command lingers in the internal
# history until the next command is entered before it vanishes, allowing you to briefly reuse
# or edit the line. If you want to make it vanish right away without entering another command,
# type a space and press return.
setopt HIST_IGNORE_SPACE

# When writing out the history file, older commands that duplicate newer ones are omitted.
setopt HIST_SAVE_NO_DUPS

# This option works like APPEND_HISTORY except that new history lines are added to the $HISTFILE
# incrementally (as soon as they are entered), rather than waiting until the shell exits.
setopt INC_APPEND_HISTORY

# When using history expansion (such as with sudo !!), on enter, first show the expanded command
# and only run it after confirmation (another enter press)
setopt HIST_VERIFY

# Remove superfluous blanks from each command line being added to the history list
setopt HIST_REDUCE_BLANKS

# When writing out the history file, by default zsh uses ad-hoc file locking to avoid known
# problems with locking on some operating systems. With this option, locking is done by means
# of the `fcntl` system call, where this method is available. This can improve performance on
# recent operating systems, and is better at avoiding history corruption when files are stored
# on NFS.
setopt HIST_FCNTL_LOCK

# Save each command's beginning time (unix timestamp) and the duration (in seconds) to the
# history file.
setopt EXTENDED_HISTORY

# beep in ZLE when a widget attempts to access a history entry which isn’t there
unsetopt HIST_BEEP
