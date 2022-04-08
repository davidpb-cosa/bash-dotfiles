#
# ~/.zshrc
#
# @author losedavidpb
#

echo "ZSH reloading --- "
echo "This version is not optimized and takes some minutes to completely"
echo "reload all dotfiles and general bash settings. If you only want to"
echo "reload exports, aliases, or functions, just insert reload-bash"

source ~/.config/shell/functions

source ~/.config/shell/zsh/options.zsh
source ~/.config/shell/zsh/zsh-functions.zsh
source ~/.config/shell/zsh/bindkeys.zsh
source ~/.config/shell/zsh/completion.zsh
source ~/.config/shell/zsh/theme.zsh

source $ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh &>/dev/null
source $ZSH_PLUGINS/zsh-history-substring-search/zsh-history-substring-search.zsh &>/dev/null
source $ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh &>/dev/null

# Display general information about current system
[[ $SHELL_STARTUP_MODE =~ "pretty" ]] && clear && sysinfo