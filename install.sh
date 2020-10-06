#!/usr/bin/env bash
#
# @author davidpb-cosa
#

DFPATH=$(find $HOME -name bash-dotfiles -not -path "*.*" | head -1)

# Create a backup in .tar to store old user dotfiles.
# This function won't work unless tar package is installed
_backup_dotfiles () {
	rm -rf $DFPATH/old-dotfiles
	mkdir $DFPATH/old-dotfiles

  cp -r ~/.bashrc $DFPATH/old-dotfiles/
  cp -r ~/.zshrc $DFPATH/old-dotfiles/
	tar -czvf $DFPATH/old-dotfiles.tar $DFPATH/old-dotfiles &>/dev/null
	rm -r $DFPATH/old-dotfiles
}

# Link new config files with default home path
_symlink_dotfiles () {
	rm -rf ~/exports &>/dev/null
	rm -rf ~/functions &>/dev/null
	rm -rf ~/aliases &>/dev/null

  ln -sf $DFPATH/.bashrc ~/.bashrc
  ln -sf $DFPATH/.zshrc ~/.zshrc
}

# Move new config files in default home path
_cp_dotfiles () {
  rm -rf ~/aliases &>/dev/null
  cp $DFPATH/aliases ~/aliases

  rm -rf ~/functions &>/dev/null
  cp $DFPATH/functions ~/functions

  rm -rf ~/exports &>/dev/null
  cp $DFPATH/exports ~/exports

	rm -rf ~/.bashrc &>/dev/null
	cp $DFPATH/.bashrc ~/.bashrc

	rm -rf ~/.zshrc &>/dev/null
	cp $DFPATH/.zshrc ~/.zshrc
}

# Execute a command in first plane showing a message
# that informs if errors were captured. Command passed
# shouldn't have any output, so it is necessary to
# change current channel to /dev/null
#
# # usage: _exec_with_mssg <command> <message>
# # output: <message> <restest: √ | X>
_exec_with_mssg () {
	if [[ $# = 2 ]]; then
		local restest="\033[1;32m√\e[m"

    # Executing command while there's no signals
    $1 &>/dev/null

		# Check if command has some errors
		if [[ $? != 0 ]]; then
			restest="\033[1;31mX\e[m"
		fi

		echo -e "${2} ${restest}"
	fi
}

# Dump command just to get sudo privilegies
clear
sudo ls /root &>/dev/null
clear

# Output message to welcome user
echo -e "\033[1;33m>>\e[m \033[1;34mBASH DOTFILES \033[4;36mINSTALLATION\e[m\e[m \033[1;33m<<\e[m"
echo -e "\033[1;34m===================================\e[m"

# Create a backup before the installation if user wants
while true; do
  read -p "Would you like to create a backup? (y/n): " yesno

  if [[ $yesno = "y" ]]; then
    _exec_with_mssg "_backup_dotfiles" "==> Creating backup for old dotfiles ..."
    break
  elif [[ $yesno = "n" ]]; then
    break
  fi
done

while true; do
  read -p "Would you like to link new dotfiles? (y/n): " yesno

  if [[ $yesno = "y" ]]; then
    _exec_with_mssg "_symlink_dotfiles" "==> Linking new dotfiles in $HOME ..."
    break
  elif [[ $yesno = "n" ]]; then
    _exec_with_mssg "_cp_dotfiles" "==> Copying new dotfiles in $HOME ..."
		_cp_dotfiles

    break
  fi
done

# Check if user wants to reboot the system
while true; do
	read -p "Reboot system? (y/n) " yesno

	if [[ $yesno = "y" ]]; then
		reboot
	elif [[ $yesno = "n" ]]; then
		break
	fi
done

echo "Finishing the installation ..."
sleep 2
