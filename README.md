<img src="logo.png" align="right" height=150px width=180px />

# My .files configuration

My personal dotfiles configuration for Unix machines.

Most of Unix command-line programs can be configured by a list of plain-text
hidden files, usually referred to as dotfiles, that are located in the user's
home directory. Since I usually use Linux, I decided to create this project
that includes all my personal dotfiles configuration.

## Structure

After the installation, all dotfiles would be stored at ~/.config/shell folder,
so any modifications has to be applied there. The following list is all the
content you should know in order to modify my dotfiles.

- __bash/:__ anything in `bash/` are dotfiles for bash
- __zsh/:__ anything in `zsh/` are dotfiles for zsh
- __aliases:__ includes all the aliases that would be loaded
- __exports:__ global variables such as PATH would be defined here
- __functions:__ utilities used to manage this .files or to simplify some tasks
- __old_dotfiles.tar:__ .files copies created if backup was done at `install.sh`
- __neofetch:__ configuration for neofetch that includes an ascii icon
- __termite:__ configuration for termite shell

## Requirements

It is important to know that any of the following packages would be install
by `install.sh` whether current machine has installed an available package
manager. In other case, you will need to install manually.

* [Neofetch](https://github.com/dylanaraps/neofetch)
* [Termite](https://github.com/thestinger/termite)
* [ZSH](https://github.com/zsh-users/zsh)
* [ZSH syntax highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
* [ZSH history substring search](https://github.com/zsh-users/zsh-history-substring-search)
* [ZSH autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)

## Shell Utilities

As it was mencioned before, `functions` file includes all the utilities that can be
executed in order to facilitate monotonous tasks. Since .files modification could
be tedious, some of these functions offer better alternatives that assures a safe
and automatic management of those files. It is important to notice that simple
commands are defined at `aliases`, so you have to check both files in order to
know what are all the available shell commands.

The following table includes all the functions and aliases used to manage
the dotfiles stored at this repository.

<table style="margin-left: auto; margin-right: auto; border: 1px solid white; border-collapse: collapse;">
    <tr>
        <th style="border: 1px solid white;">Name</th>
        <th style="border: 1px solid white;">Type</th>
        <th style="border: 1px solid white;">Description</th>
        <th style="border: 1px solid white;">Syntax</th>
    </tr>
    <tr>
        <td style="border: 1px solid white;">reload-all-bash</td>
        <td style="border: 1px solid white;">Function</td>
        <td style="border: 1px solid white;">
            Reload all dotfiles and bash settings. It is important
            to notice that ZSH shell is not optimized, so <br>it will
            take a lot of time to fully load into shell. Please,
            use reload-bash instead whether you only<br> want to reload
            functions, aliases, or exports.
        </td>
        <td style="border: 1px solid white;">reload-all-bash</td>
    </tr>
    <tr>
        <td style="border: 1px solid white;">reload-bash</td>
        <td style="border: 1px solid white;">Function</td>
        <td style="border: 1px solid white;">
            Reload all dotfiles to apply any changes
            that was done at internal files
        </td>
        <td style="border: 1px solid white;">reload-bash</td>
    </tr>
    <tr>
        <td style="border: 1px solid white;">shellhelp</td>
        <td style="border: 1px solid white;">Function</td>
        <td style="border: 1px solid white;">
            Show information about the passed utility whether
            it truly exists. If no arguments were passed, <br>this
            command would show help information for any single
            function.
        </td>
        <td style="border: 1px solid white;">shellhelp [NAME]</td>
    </tr>
    <tr>
        <td style="border: 1px solid white;">setexport</td>
        <td style="border: 1px solid white;">Function</td>
        <td style="border: 1px solid white;">
            Update value for passed global variable or
            add a new one which passed value. Changes would<br>
            be applied before executing reload-bash.
        </td>
        <td style="border: 1px solid white;">setexport NAME VALUE</td>
    </tr>
    <tr>
        <td style="border: 1px solid white;">rmexport</td>
        <td style="border: 1px solid white;">Function</td>
        <td style="border: 1px solid white;">
            Remove passed global variable whether it exists
            at current exports file. Changes would be applied<br>
            before executing reload-bash.
        </td>
        <td style="border: 1px solid white;">rmexport NAME</td>
    </tr>
    <tr>
        <td style="border: 1px solid white;">chshell</td>
        <td style="border: 1px solid white;">Function</td>
        <td style="border: 1px solid white;">
            Change current shell whether passed value it is
            an available and valid shell name. Changes would<br>
            be applied before executing reload-bash.
        </td>
        <td style="border: 1px solid white;">chshell NAME</td>
    </tr>
    <tr>
        <td style="border: 1px solid white;">set-shell-simple</td>
        <td style="border: 1px solid white;">Function</td>
        <td style="border: 1px solid white;">
            If this command is executed, next time shell runs it
            would only load necessary files, since performance<br>
            is most important than appearance.
        </td>
        <td style="border: 1px solid white;">set-shell-simple</td>
    </tr>
    <tr>
        <td style="border: 1px solid white;">set-shell-pretty</td>
        <td style="border: 1px solid white;">Function</td>
        <td style="border: 1px solid white;">
            If this command is executed, next time shell runs it
            would load all files, since appearance is most<br> important
            than performance.
        </td>
        <td style="border: 1px solid white;">set-shell-pretty</td>
    </tr>
</table>

## Installation

```
git clone https://github.com/losedavidpb/bash-dotfiles
cd bash-dotfiles

./install.sh

rm -rf bash-dotfiles
source ~/<RC_FILE>
```
