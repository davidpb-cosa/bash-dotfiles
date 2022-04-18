#
# ~/.bashrc
#
# @author losedavidpb
#

source ~/.config/shell/functions

export PS1="$MAGENTA\u$END_COLOR :: $CYAN$(basename $(dirname "$PWD"))/$(basename "$PWD")$ENDCOLOR $RED>$ENDCOLOR$WHITE " 
[[ $CD_MODE =~ "on" ]] && cd ~
[[ $SHELL_STARTUP_MODE =~ "pretty" ]] && sysinfo