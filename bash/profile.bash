#!/usr/bin/env bash
#
# ~/.profile
#
# @author losedavidpb
#

[ -n "$SHELL" ] && $SHELL && return

if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi