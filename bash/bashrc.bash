#!/usr/bin/env bash
#
# ~/.bashrc
#
# @author losedavidpb
#

source ~/.config/shell/functions

export PS1="$MAGENTA\u$END_COLOR :: $CYAN\w$ENDCOLOR $IRED>$ENDCOLOR " 

[[ $SHELL_STARTUP_MODE =~ "pretty" ]] && sysinfo