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
source ./functions

# Flags for options
silent_flag=0
no_deps_flag=0

# Personal customization
terminal_name="termite"
shell_name="zsh"

# List of packages that will be installed based on
# current package manager. It is important to notice
# that installation does not include all managers
declare -a _packages=(
	git dos2unix zsh
	build-essential neofetch
 	g++ libgtk-3-dev xinit
 	gtk-doc-tools gnutls-bin
 	valac intltool libpcre2-dev
 	libglib3.0-cil-dev libgnutls28-dev
 	libgirepository1.0-dev libxml2-utils gperf
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

function _main_header () {
	echo -e "${BOLD_YELLOW}>>${CLOSE_COLOR} ${BOLD_BLUE} SETUP FOR ${UNDERLINE_CYAN}BASH DOTFILES${CLOSE_COLOR}${CLOSE_COLOR} ${BOLD_YELLOW}<<${CLOSE_COLOR}"
	echo -e "${BOLD_BLUE}==============================${CLOSE_COLOR}"
}

function _install_packages () {
	for (( i=0; i<${#_packages[@]}; i++ )); do
		local package_name=${_packages[$i]}

		(( $silent_flag == 0)) && echo -n ">> Installing package $package_name ... "

		case $PACKAGE_MANAGER in
			"yum")
				yes | sudo yum install $package_name -q &>/dev/null
				(( $? == 0 )) || echo "BAD" || exit 1
			;;

			"pacman")
				yes | sudo pacman -Syyuq $package_name &>/dev/null
				(( $? == 0 )) || echo "BAD" || exit 1
			;;

			"emerger")
				yes | sudo emerge $package_name &>/dev/null
				(( $? == 0 )) || echo "BAD" || exit 1
			;;

			"zypp")
				yes | sudo zypper ar $package_name &>/dev/null
				(( $? == 0 )) || echo "BAD" || exit 1
			;;

			"apt")
				sudo apt-get -qq install -y $package_name &>/dev/null
				(( $? == 0 )) || echo "BAD" || exit 1
			;;

			"apt-get")
				sudo apt-get -qq install -y $package_name &>/dev/null
				(( $? == 0 )) || echo "BAD" || exit 1
			;;

			"apk")
				yes | sudo apk add $package_name &>/dev/null
				(( $? == 0 )) || echo "BAD" || exit 1
			;;

			*) _showerr "package manager not available" ;;
		esac

		(( $silent_flag == 0)) && echo "OK"
	done
}

function _install_vte_ng () {
	(( $silent_flag == 0)) && echo -n ">> Installing package vte ... "

    if [[ ! -d vte-ng ]]; then
		sudo rm -rf vte-ng &>/dev/null
        sudo git clone https://github.com/thestinger/vte-ng.git --quiet >/dev/null
        sudo find vte-ng/* -type f -print0 | xargs -0 sudo dos2unix -- &>/dev/null
    fi

    export LIBRARY_PATH="/usr/include/gtk-3.0:$LIBRARY_PATH"
    cd vte-ng && sudo ./autogen.sh &>/dev/null && sudo make -s &>/dev/null && sudo make -s install &>/dev/null
    
    cd ..; (( $silent_flag == 0)) && echo "OK"
	sudo rm -rf vte-ng &>/dev/null
}

function _install_termite () {
	(( $silent_flag == 0)) && echo -n ">> Installing package termite ... "
    
    if [[ ! -d termite ]]; then
		sudo rm -rf termite &>/dev/null
        sudo git clone --recursive https://github.com/thestinger/termite.git --quiet >/dev/null
        sudo find termite/* -type f -print0 | xargs -0 sudo dos2unix -- &>/dev/null
    fi

    cd termite && sudo make -s 2>/dev/null
    sudo make -s install 2>/dev/null

    sudo ldconfig 2>/dev/null
    sudo mkdir -p /lib/terminfo/x 2>/dev/null
    sudo rm /lib/terminfo/x/xterm-termite 2>/dev/null
    sudo ln -s /usr/local/share/terminfo/x/xterm-termite /lib/terminfo/x/xterm-termite

    sudo update-alternatives --install /usr/bin/x-terminal-emulator \
        x-terminal-emulator /usr/local/bin/termite 60 &>/dev/null
	
    cd ..; (( $silent_flag == 0)) && echo "OK"
	sudo rm -rf termite &>/dev/null
}

function _install_zsh_plugins () {
	(( $silent_flag == 0)) && echo -n ">> Install zsh plugins ... "

	for zsh_plugin in "${!_zsh_plugins[@]}"; do
		local zsh_plugin_url=${_zsh_plugins[$zsh_plugin]}
		sudo rm -rf /usr/share/zsh/plugins/$zsh_plugin 2>/dev/null
		sudo mkdir -p /usr/share/zsh/plugins/$zsh_plugin 2>/dev/null
		
		sudo git clone $zsh_plugin_url --quiet &>/dev/null
		sudo find ./$zsh_plugin/* -type f -print0 | xargs -0 sudo dos2unix -- &>/dev/null
		sudo cp -rf ./$zsh_plugin/* /usr/share/zsh/plugins/$zsh_plugin &>/dev/null
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
	ln -sf ~/.config/shell/zsh/zshrc.zsh ~/.zshrc

	cp -rf $PWD/hyper/hyper.js ~/.config/Hyper/
	cp -rf $PWD/neofetch/config.conf ~/.config/neofetch/
	cp -rf $PWD/termite/config ~/.config/termite/
}

function _customization () {
	local temp_file=$(mktemp)

	echo "${BOLD_YELLOW}>>${CLOSE_COLOR} ${BOLD_BLUE} SETUP FOR ${UNDERLINE_CYAN}BASH DOTFILES${CLOSE_COLOR}${CLOSE_COLOR} ${BOLD_YELLOW}<<${CLOSE_COLOR}\n" >> $temp_file
	echo "${BOLD_BLUE}==============================${CLOSE_COLOR}\n" >> $temp_file
	echo "Select one of the following terminals:" >> $temp_file

	local menu_items=('Termite' 'Hyper')
	interactive_menu "$temp_file" "0" "${menu_items[@]}"
	
	case "$?" in
		0) terminal_name="termite" ;;
		1) terminal_name="hyper" ;;
	esac

	echo "${BOLD_YELLOW}>>${CLOSE_COLOR} ${BOLD_BLUE} SETUP FOR ${UNDERLINE_CYAN}BASH DOTFILES${CLOSE_COLOR}${CLOSE_COLOR} ${BOLD_YELLOW}<<${CLOSE_COLOR}\n" > $temp_file
	echo "${BOLD_BLUE}==============================${CLOSE_COLOR}\n" >> $temp_file
	echo "Select one of the following shells:" >> $temp_file

	menu_items=('Bash' 'ZSH')
	interactive_menu "$temp_file" "0" "${menu_items[@]}"

	case "$?" in
		0) shell_name="bash" ;;
		1) shell_name="zsh" ;;
	esac

	rm $temp_file
}

function _apply_customization () {
	case $terminal_name in
		"termite") setexport TERMINAL /usr/bin/termite ;;
		"hyper") setexport TERMINAL /usr/bin/hyper ;;
	esac

	case $shell_name in
		"bash")
			setexport SHELL /usr/bin/bash
			setexport SHELL_NAME bash
		;;
		"zsh")
			setexport SHELL /usr/bin/zsh
			setexport SHELL_NAME zsh
		;;
	esac
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
	_main_header
fi

_prepare_dotfiles

(( $silent_flag == 0 )) && _customization && clear && _main_header

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
	_install_vte_ng
	_install_termite
fi

_apply_customization

unset _packages _zsh_plugins
unset terminal_name shell_name
unset no_deps_flag

if (( $silent_flag == 0 )); then
	echo "Current shell would be reload..."
	unset silent_flag
	reload-bash
	clear; reload-all-bash
fi

unset silent_flag