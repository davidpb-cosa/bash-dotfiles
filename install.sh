#!/usr/bin/env bash
#
# @author losedavidpb
#

# Create a .tar backup to store old user dotfiles.
# This function won't work unless tar package is installed!
_backup_dotfiles () {
	rm -rf ~/.config/shell/old-dotfiles
	mkdir -p ~/.config/shell/old-dotfiles

  	cp -r ~/.bashrc ~/.config/shell/old-dotfiles/
  	cp -r ~/.zshrc ~/.config/shell/old-dotfiles/

	tar -czvf ~/.config/shell/old-dotfiles.tar ~/.config/shell/old-dotfiles &>/dev/null
	rm -rf ~/.config/shell/old-dotfiles
}

# Moves all dotfiles to ~/.config/shell folder and links all the rc files
_mv_link_dotfiles () {
	cp $PWD/ascii_icon ~/.config/shell
	cp $PWD/exports ~/.config/shell
	cp $PWD/aliases ~/.config/shell
	cp $PWD/functions ~/.config/shell
	cp $PWD/.bashrc ~/.config/shell/rc
	cp $PWD/.zshrc ~/.config/shell/rc
	
	ln -sf ~/.config/shell/rc/.bashrc ~/.bashrc
	ln -sf ~/.config/shell/rc/.zshrc ~/.zshrc
	
	cp $PWD/neofetch/config.conf ~/.config/neofetch/
}

clear
sudo ls /root &>/dev/null
clear

echo -e "\033[1;33m>>\e[m \033[1;34m SETUP FOR \033[4;36mBASH DOTFILES\e[m\e[m \033[1;33m<<\e[m"
echo -e "\033[1;34m==============================\e[m"

mkdir -p ~/.config/neofetch &>/dev/null
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
  	_backup_dotfiles
    break
  elif [[ $yesno = "n" ]]; then
    break
  fi
done

echo ">> Moving and linking all the bash .files ..."
_mv_link_dotfiles

rm -rf ~/.bash_profile &>/dev/null
rm -rf ~/.bash_logout &>/dev/null

echo "Finishing the installation ..."
sleep 2
