#!/usr/bin/env bash
#
# @author losedavidpb
#

_backup_dotfiles () {
	rm -rf ~/.config/shell/old-dotfiles
	mkdir -p ~/.config/shell/old-dotfiles

  	cp -rf ~/.bashrc ~/.config/shell/old-dotfiles/
  	cp -rf ~/.zshrc ~/.config/shell/old-dotfiles/

	tar -czf ~/.config/shell/old-dotfiles.tar ~/.config/shell/old-dotfiles
	rm -rf ~/.config/shell/old-dotfiles
}

_mv_link_dotfiles () {
	cp -rf $PWD/ascii_icon ~/.config/shell
	cp -rf $PWD/exports ~/.config/shell
	cp -rf $PWD/aliases ~/.config/shell
	cp -rf $PWD/functions ~/.config/shell
	cp -rf $PWD/.bashrc ~/.config/shell/rc
	cp -rf $PWD/.zshrc ~/.config/shell/rc
	
	ln -sf ~/.config/shell/rc/.bashrc ~/.bashrc
	ln -sf ~/.config/shell/rc/.zshrc ~/.zshrc
	
	cp -rf $PWD/neofetch/config.conf ~/.config/neofetch/
	cp -rf $PWD/termite/config ~/.config/termite/
}

clear
sudo ls /root &>/dev/null
clear

echo -e "\033[1;33m>>\e[m \033[1;34m SETUP FOR \033[4;36mBASH DOTFILES\e[m\e[m \033[1;33m<<\e[m"
echo -e "\033[1;34m==============================\e[m"

mkdir -p ~/.config/neofetch &>/dev/null
mkdir -p ~/.config/termite &>/dev/null
mkdir -p ~/.config/shell/rc &>/dev/null
mkdir -p ~/.config/shell/tmp &>/dev/null
mkdir -p ~/.config/shell/cache &>/dev/null

touch ~/.config/shell/tmp/.bash_history &>/dev/null
touch ~/.config/shell/tmp/.zhistory &>/dev/null
touch ~/.config/shell/cache/.zcompdump &>/dev/null

rm -rf ~/.bash_history &>/dev/null
rm -rf ~/.zcompdump &>/dev/null
rm -rf ~/.zhistory &>/dev/null

while true; do
  read -p "Would you like to create a backup? (y/n): " yesno

  if [[ $yesno = "y" ]]; then
  	echo ">> Creating the backup for old .files ..."
  	_backup_dotfiles &>/dev/null
    break
  elif [[ $yesno = "n" ]]; then
    break
  fi
done

rm -rf ~/.config/neofetch/*
rm -rf ~/.config/termite/*

echo ">> Moving and linking all the bash .files ..."
_mv_link_dotfiles &>/dev/null

rm -rf ~/.bash_profile &>/dev/null
rm -rf ~/.bash_logout &>/dev/null

echo "Finishing the installation ..."
sleep 2
