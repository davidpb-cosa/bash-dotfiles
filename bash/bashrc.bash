#!/usr/bin/env bash
#
# ~/.bashrc
#
# @author losedavidpb
#

source ~/.config/shell/exports
source ~/.config/shell/aliases
source ~/.config/shell/functions

export PS1="$MAGENTA\u$END_COLOR :: $CYAN\w$ENDCOLOR $IRED>$ENDCOLOR " 

cd ~
[[ $SHELL_STARTUP_MODE =~ "pretty" ]] && sysinfo