#!/usr/bin/env bash
#
# ~/.bashrc
#
# @author losedavidpb
#

source ~/.config/shell/exports
source ~/.config/shell/functions
source ~/.config/shell/aliases

# Current PROMPT string for bash
PS1="$MAGENTA\s[$ENDCOLOR$EMMAGENTA\u \W$ENDCOLOR$MAGENTA] >>> $ENDCOLOR"

# Display general information about current system
sysinfo
