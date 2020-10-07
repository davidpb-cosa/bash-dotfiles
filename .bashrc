#!/usr/bin/env bash
#
# ~/.bashrc
#
# @author losedavidpb
#

# Store absolute cosa-dotfiles path
_DFPATH=$(find $HOME -name bash-dotfiles -not -path "*.*" | head -1)

if [[ -z $_DFPATH ]]; then
	source ~/exports
	source ~/functions
	source ~/aliases
else
	source $_DFPATH/exports
	source $_DFPATH/functions
	source $_DFPATH/aliases
fi

PS1="$MAGENTA\[$ENDCOLOR$EMMAGENTA\u \W$ENDCOLOR$MAGENTA\] >>> $ENDCOLOR"
sysinfo

unset _DFPATH
