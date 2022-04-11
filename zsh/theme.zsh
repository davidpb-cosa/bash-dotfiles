#
#!/bin/zsh
#

source ~/.config/shell/zsh/zsh-functions.zsh

autoload -U compinit colors zcalc
compinit -d ~/.config/shell/.zcompdump
colors

zstyle ':vcs_info:*' formats ' %s(%F{red}%b%f)'

# Apply different settings for different terminals
case $(basename "$(cat "/proc/$PPID/comm")") in
  login) export RPROMPT="%{$fg_bold[cyan]%}%{$reset_color%}" ;;
  *) export RPROMPT='$(git_prompt_string)' ;;
esac

export PROMPT="%F{magenta}%n%f :: %F{cyan}%2d%f %F{red}>%f "