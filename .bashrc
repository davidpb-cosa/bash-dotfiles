#!/usr/bin/env bash
#
# ~/.bashrc
#
# @author davidpb-cosa
#

# Store absolute cosa-dotfiles path
_DFPATH=$(find $HOME -name bash-dotfiles -not -path "*.*" | head -1)

source $_DFPATH/exports
source $_DFPATH/aliases
source $_DFPATH/functions

unset _DFPATH
