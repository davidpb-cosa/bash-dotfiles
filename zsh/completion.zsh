#
#!/bin/zsh
#

zstyle ':completion:*' menu select													# Menu select completion
zstyle ':completion:*' group-name '' 												# Group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate         # Enable approximate matches for completion
zstyle ':completion:*' insert-tab pending                                           # Pasting with tabs doesn't perform completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       					# Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         					# Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' rehash true                              					# Automatically find new executables in path

# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.config/shell