#!/usr/bin/env bash
#
# ~/.bashrc
#
# @author davidpb-cosa
#

# Store absolute cosa-dotfiles path
_DFPATH=$(find $HOME -name bash-dotfiles -not -path "*.*" | head -1)

if [[ -z $_DFPATH ]]; then
	source ~/exports
	source ~/aliases
	source ~/functions
else
	source $_DFPATH/exports
	source $_DFPATH/aliases
	source $_DFPATH/functions
fi

unset _DFPATH
