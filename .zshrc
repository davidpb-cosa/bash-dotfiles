#
# ~/.zshrc
#
#
# @author davidpb-cosa
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

# Enable autocompletion using a cache for faster startup
autoload -Uz compinit
typeset -i updated_at=$(
	date +'%j' -r ~/.zcompdump 2>/dev/null ||
	stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null
)

if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi

zmodload -i zsh/complist

	## OPTIONS SECTION

setopt correct											# Auto correct mistakes
setopt no_list_ambiguous						# Avoid list ambiguous
setopt extendedglob                 # Extended globbing. Allows using regular expressions with *
setopt nocaseglob                   # Case insensitive globbing
unsetopt nomatch					# Passes the command as is instead of reporting pattern matching failure see Chrysostomus/manjaro-zsh-config#14
setopt rcexpandparam                # Array expension with parameters
setopt nocheckjobs                  # Don't warn about running processes when exiting
setopt numericglobsort              # Sort filenames numerically when it makes sense
setopt nobeep                       # No beep
setopt completealiases				# Set aliases completion
setopt autocd                       # If only directory path is entered, cd there.

setopt correct_all 					# Autocorrect commands
setopt interactive_comments 		# Allow comments in interactive shells

setopt HIST_IGNORE_DUPS				# Remove duplicated lines in ZSH history
setopt appendhistory                # Immediately append history instead of overwriting
setopt histignorealldups            # If a new command is a duplicate, remove the older one
setopt hist_reduce_blanks 			# Remove superfluous blanks from history items
setopt inc_append_history 			# Save history entries as soon as they are entered
setopt share_history 				# Share history between different instances of the shell

setopt auto_list 					# Automatically list choices on ambiguous completion
setopt auto_menu 					# Automatically use menu completion
setopt always_to_end 				# Move cursor to end if word had one match

zstyle ':completion:*' menu select											# Menu select completion
zstyle ':completion:*' group-name '' 										# Group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # Enable approximate matches for completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       			# Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         			# Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' rehash true                              			# Automatically find new executables in path

# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

	## KEYBINDINGS SECTION

bindkey -e
bindkey '^[[7~' beginning-of-line                               # Home key
bindkey '^[[H' beginning-of-line                                # Home key

if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line                # [Home] - Go to beginning of line
fi

bindkey '^[[8~' end-of-line                                     # End key
bindkey '^[[F' end-of-line                                      # End key

if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}" end-of-line                       # [End] - Go to end of line
fi

bindkey '^[[2~' overwrite-mode                                  # Insert key
bindkey '^[[3~' delete-char                                     # Delete key
bindkey '^[3;5~' delete-char									# Delete key
bindkey '^[[C'  forward-char                                    # Right key
bindkey '^[[D'  backward-char                                   # Left key
bindkey '^[[5~' history-beginning-search-backward               # Page up key
bindkey '^[[6~' history-beginning-search-forward                # Page down key

# Navigate words with ctrl+arrow keys
bindkey '^[Oc' forward-word                                     #
bindkey '^[Od' backward-word                                    #
bindkey '^[[1;5D' backward-word                                 #
bindkey '^[[1;5C' forward-word                                  #
bindkey '^H' backward-kill-word                                 # delete previous word with ctrl+backspace
bindkey '^[[Z' undo                                             # Shift+tab undo last action

# Default help command
autoload -U run-help
autoload run-help-git
autoload run-help-svn
autoload run-help-svk

unalias run-help
alias help=run-help

# ZSH Default colors:
# https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg

	## THEMING SECTION

autoload -U compinit colors zcalc
compinit -d ~/.config/zsh/.zcompdump
colors

# Enable substitution for prompt
setopt prompt_subst

# Define PROMPT variable according to GID
if [[ $(id -G) = 0 ]]; then
	PROMPT="%(?.%F{green}√.%F{red}X) %F{111}[%f %B%F{117}/root %1~%f%b %F{111}] >>> %f"
else
	PROMPT="%(?.%F{green}√.%F{red}X) %F{133}[%f %B%F{134}%n %1~%f%b %F{133}] >>> %f"
fi

# Modify the colors and symbols in these variables as desired.
GIT_PROMPT_SYMBOL="%{$fg[blue]%}±"                              # plus/minus     - clean repo
GIT_PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
GIT_PROMPT_AHEAD="%{$fg[red]%}ANUM%{$reset_color%}"             # A"NUM"         - ahead by "NUM" commits
GIT_PROMPT_BEHIND="%{$fg[cyan]%}BNUM%{$reset_color%}"           # B"NUM"         - behind by "NUM" commits
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"     # lightning bolt - merge conflict
GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"       # red circle     - untracked files
GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}●%{$reset_color%}"     # yellow circle  - tracked files modified
GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"        # green circle   - staged changes present = ready for "git push"

# Show Git branch/tag, or name-rev if on detached head
parse_git_branch () {
  ( git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD ) 2> /dev/null
}

# Show different symbols as appropriate for various Git repository states
parse_git_state () {
  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"

  # Compose this value via multiple conditional appends.
  local GIT_STATE=""

  if [ "$NUM_AHEAD" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
  fi

  if [ "$NUM_BEHIND" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
  fi

  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
  fi

  if ! git diff --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
  fi

  if [[ -n $GIT_STATE ]]; then
    echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
  fi
}

# Show the string format of git prompt
git_prompt_string () {
  local git_where="$(parse_git_branch)"

  # If inside a Git repository, print its branch and state
  [ -n "$git_where" ] && echo "$GIT_PROMPT_SYMBOL$(parse_git_state)$GIT_PROMPT_PREFIX%{$fg[yellow]%}${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX"

  # If not inside the Git repo, print exit codes of last command (only if it failed)
  [ ! -n "$git_where" ] && echo "%{$fg[red]%} %(?..[%?])"
}

# Color man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-r

	## PLUGINS SECTION

# Use syntax highlighting and history substring search
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# bind UP and DOWN arrow keys to history substring search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Apply different settigns for different terminals
case $(basename "$(cat "/proc/$PPID/comm")") in
  login)
    	RPROMPT="%{$fg[red]%} %(?..[%?])"
    	alias x='startx ~/.xinitrc'      # Type name of desired desktop after x, xinitrc is configured for it
    ;;
  *)
        RPROMPT='$(git_prompt_string)'

        # Base16 Shell color themes.
		# possible themes: 3024, apathy, ashes, atelierdune, atelierforest, atelierhearth,
		# atelierseaside, bespin, brewer, chalk, codeschool, colors, default, eighties,
		# embers, flat, google, grayscale, greenscreen, harmonic16, isotope, londontube,
		# marrakesh, mocha, monokai, ocean, paraiso, pop (dark only), railscasts, shapesifter,
		# solarized, summerfruit, tomorrow, twilight
      theme="tomorrow"

      # Possible variants: dark and light
			shade="dark"

			BASE16_SHELL="/usr/share/zsh/scripts/base16-shell/base16-$theme.$shade.sh"
			[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

			# Use autosuggestion
			source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
			ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
  		ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
    ;;
esac

unset _DFPATH

# Display general information about current system
sysinfo
