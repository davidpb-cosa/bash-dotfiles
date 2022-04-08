#!/usr/bin/env bash
#
# install.sh - installation for my dotfiles
#
# SYNTAX
#	
#	./install.sh [-q|--quiet]
#
# DESCRIPTION
#
# 	Installs all my dotfiles on your current user's working directory.
#
# 	This script would not only prepare my dotfiles on your home directory,
# 	since ZSH plugins and necessary packages will be installed too whether
#	there is a valid package manager installed on your current machine.
#
# 	To prevent errors, installation would ask you to create a backup for your
#	old dotfiles, which will be stored at current dotfiles path (see exports).
#
#	Relative to configuration, you can modify exports file to adjust some settings
#	like dotfiles path. It is important to notice that any changes you make are not
#	considered and can provoke errors, so please modify exports by your own risk!
#
# ARGUMENTS
#
#	[-q | --quiet]			Execute installation with no output messages at
#							current shell. This was included to offer a way
#							to use this command at bash scripts. You should
#							know that dotfiles backup would be done if this
#							option has been set to current command
#
# AUTHOR
#
#	losedavidpb (https://github.com/losedavidpb)
#

source ./exports

# Flags for options
silent_flag=0
no_deps_flag=0

# List of packages that will be installed based on
# current package manager. It is important to notice
# that installation does not include all managers
declare -a _packages=(
	git dos2unix zsh
)

# List of ZSH plugins that will be installed. Installation
# will be done manually to assure that lots of different
# machines could install it without errors
declare -A _zsh_plugins=(
	[zsh-autosuggestions]=https://github.com/zsh-users/zsh-autosuggestions
	[zsh-syntax-highlighting]=https://github.com/zsh-users/zsh-syntax-highlighting
	[zsh-history-substring-search]=https://github.com/zsh-users/zsh-history-substring-search
)

function _showerr () {
	if (( $# == 1 )); then
		echo "error: install: $1" 2>&1
		exit 1
	fi
}

function _install_packages () {
	(( $silent_flag == 0)) && echo -n ">> Install necessary packages ... "

	for (( i=0; i<${#_packages[@]}; i++ )); do
		local package_name=${_packages[$i]}

		case $PACKAGE_MANAGER in
			"yum")
				yes | sudo yum install $package_name -q &>/dev/null
				(( $? == 0 )) || echo "BAD" || exit 1
			;;
			"pacman")
				yes | sudo pacman -Syyuq $package_name &>/dev/null
				(( $? == 0 )) || echo "BAD" || exit 1
			;;
			"apt")
				sudo apt-get -qq install -y $package_name &>/dev/null
				(( $? == 0 )) || echo "BAD" || exit 1
			;;
			*) _showerr "package manager not available" ;;
		esac
	done

	(( $silent_flag == 0)) && echo "OK"
}

function _install_zsh_plugins () {
	(( $silent_flag == 0)) && echo -n ">> Install zsh plugins ... "

	for zsh_plugin in "${!_zsh_plugins[@]}"; do
		local zsh_plugin_url=${_zsh_plugins[$zsh_plugin]}
		sudo rm -rf /usr/share/zsh/plugins/$zsh_plugin 2>/dev/null
		sudo mkdir -p /usr/share/zsh/plugins/$zsh_plugin 2>/dev/null
		
		git clone $zsh_plugin_url --quiet &>/dev/null
		sudo find $zsh_plugin/* -type f -print0 | xargs -0 sudo dos2unix -- &>/dev/null
		sudo cp -rf $zsh_plugin/* /usr/share/zsh/plugins/$zsh_plugin &>/dev/null
		sudo rm -rf $zsh_plugin &>/dev/null
	done

	(( $silent_flag == 0)) && echo "OK"
}

function _prepare_dotfiles () {
	rm -rf ~/.config/shell/ &>/dev/null

	mkdir -p ~/.config/Hyper &>/dev/null
	mkdir -p ~/.config/neofetch &>/dev/null
	mkdir -p ~/.config/termite &>/dev/null
	mkdir -p ~/.config/shell/bash &>/dev/null
	mkdir -p ~/.config/shell/zsh &>/dev/null

	touch ~/.config/shell/.bash_history &>/dev/null
	touch ~/.config/shell/.zhistory &>/dev/null
	touch ~/.config/shell/.zcompdump &>/dev/null

	rm -rf ~/.bash_history &>/dev/null
	rm -rf ~/.zcompdump &>/dev/null
	rm -rf ~/.zhistory &>/dev/null
}

function _backup_dotfiles () {
	rm -rf ~/.config/shell/old-dotfiles
	mkdir -p ~/.config/shell/old-dotfiles

  	cp -rf ~/.bashrc ~/.config/shell/old-dotfiles/
  	cp -rf ~/.zshrc ~/.config/shell/old-dotfiles/

	tar -czf ~/.config/shell/old-dotfiles.tar ~/.config/shell/old-dotfiles
	rm -rf ~/.config/shell/old-dotfiles
}

function _install_dotfiles () {
	cp -rf $PWD/bash/*.bash ~/.config/shell/bash

	cp -rf $PWD/zsh/*.zsh ~/.config/shell/zsh
	mv ~/.config/shell/zsh/zshrc.zsh ~/.config/shell/zsh/.zshrc

	cp -rf $PWD/neofetch/ascii_icon ~/.config/neofetch
	cp -rf $PWD/exports ~/.config/shell
	cp -rf $PWD/aliases ~/.config/shell
	cp -rf $PWD/functions ~/.config/shell

	ln -sf ~/.config/shell/bash/bashrc.bash ~/.bashrc
	ln -sf ~/.config/shell/bash/profile.bash ~/.profile
	ln -sf ~/.config/shell/zsh/.zshrc ~/.zshrc

	cp -rf $PWD/hyper/hyper.js ~/.config/Hyper/
	cp -rf $PWD/neofetch/config.conf ~/.config/neofetch/
	cp -rf $PWD/termite/config ~/.config/termite/
}

(( $# < 0 || $# > 1 )) && _showerr "invalid number of parameters"

while (( $# > 0 )); do
	case $1 in
		"-q") silent_flag=1; shift ;;
		"--quiet") silent_flag=1; shift ;;
		*) _showerr "$1 is not a valid option" ;;
	esac
done

[[ $PACKAGE_MANAGER =~ "unkown" ]] && no_deps_flag=1

if (( $silent_flag == 0 )); then
	clear; sudo ls /root &>/dev/null; clear
	echo -e "\033[1;33m>>\e[m \033[1;34m SETUP FOR \033[4;36mBASH DOTFILES\e[m\e[m \033[1;33m<<\e[m"
	echo -e "\033[1;34m==============================\e[m"
fi

_prepare_dotfiles

if (( $silent_flag == 0 )); then
	while true; do
  		read -p "Would you like to create a backup? (y/n): " yesno

  		if [[ $yesno = "y" ]]; then
  			echo -n ">> Creating the backup for old .files ... "
  			_backup_dotfiles &>/dev/null
			echo "OK"; break
  		elif [[ $yesno = "n" ]]; then
    		break
  		fi
	done
else
	_backup_dotfiles &>/dev/null
fi

rm -rf ~/.config/neofetch/*
rm -rf ~/.config/termite/*

(( $silent_flag == 0 )) && echo -n ">> Moving and linking all the bash .files ... "
_install_dotfiles &>/dev/null
(( $silent_flag == 0 )) && echo "OK"

rm -rf ~/.bash_profile &>/dev/null
rm -rf ~/.bash_logout &>/dev/null

if (( $no_deps_flag == 0 )); then
	_install_packages
	_install_zsh_plugins
fi

unset _packages _zsh_plugins
unset silent_flag no_deps_flag