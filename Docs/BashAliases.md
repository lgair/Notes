# Reference Document for `.bash_aliases`

This document provides a comprehensive reference for the aliases defined in your `.bash_aliases` file. Each section contains aliases grouped by their functionalities.

## Table of Contents

- [General](#general)
- [Python](#python)
- [Vim](#vim)
- [Git](#git)
- [File Operations](#file-operations)
- [File Management](#file-management)
- [System & Device Info](#system--device-info)
- [Clipboard](#clipboard)
- [GPG](#gpg)
- [Jenkins](#jenkins)
- [Miscellaneous](#miscellaneous)
- [Git Aliases](#git-aliases)
- [Navigation Aliases](#navigation-aliases)
- [System Commands](#system-commands)
- [Custom Shortcuts](#custom-shortcuts)

## General

- `alias Bourne-Again='source $HOME/.bashrc && echo "sh has been Bourne Again!"'`  
  Reloads the `.bashrc` file and confirms the shell has been reinitialized.

## Python

- `alias python='python3'`  
  Redirects `python` command to Python 3.
  
- `alias py='python'`  
  Short alias for Python 3.
  
- `alias ve='python3 -m venv ./venv'`  
  Creates a virtual environment in the `./venv` directory.
  
- `alias va='source ./venv/bin/activate'`  
  Activates the virtual environment.

## Vim

- `alias VIM-Settings='vim ~/.vimrc'`  
  Opens the Vim configuration file.
  
- `alias aliases='vim ~/.bash_aliases && Bourne-Again'`  
  Opens the alias file and reloads Bash.
  
- `alias functions='vim ~/.bash_functions && Bourne-Again'`  
  Opens the functions file and reloads Bash.

## Git

- `alias gp-fwl='cg && git push --force-with-lease'`  
  Pushes changes with force and lease.
  
- `alias gitroot='cd $(git rev-parse --show-toplevel)'`  
  Changes to the root directory of the Git repository.
  
- `alias ShowBranchesVerbosely='git branch -v -a'`  
  Displays all branches with verbose information.
  
- `alias git_clean='git clean -xfdf'`  
  Cleans untracked files and directories.
  
- `alias gitSSHRegex='s|https://(.*?)/|git@\1:|g'`  
  Converts HTTPS Git URLs to SSH format.

## File Operations

- `alias cp='rsync --progress -ah'`  
  Copies files with progress display.
  
- `alias cpv='rsync -ah --info=progress2'`  
  More verbose copying with rsync.

- `alias untar='tar -zxvf'`  
  Extracts `.tar.gz` files.

## File Management

- `alias mv='mv -i'`  
  Prompts before overwriting files.
  
- `alias mvv='mv -iv'`  
  Verbose version of the move command.
  
- `alias rm='rm -i'`  
  Prompts before deleting files.

## System & Device Info

- `alias UARTlocation='dmesg | grep tty'`  
  Displays the location of UART devices.
  
- `alias CheckMountPoints='df -aTh'`  
  Shows mounted devices in a human-readable format.

## Clipboard

- `alias pbcopy='xclip -selection clipboard'`  
  Copies content to the clipboard.
  
- `alias pbpaste='xclip -selection clipboard -o'`  
  Pastes content from the clipboard.

## GPG

- `alias secretGPGKeyList='gpg --list-secret-keys --keyid-format=long'`  
  Lists secret GPG keys.
  
- `alias listGPGKeys='gpg --list-keys'`  
  Lists public GPG keys.

## Jenkins

- `alias JenkinsServer='ssh -p4222 krontech@debian.krontech.ca'`  
  Connects to the Jenkins server via SSH.

## Miscellaneous

- `alias JSpackages='npm list -g --depth=0'`  
  Lists globally installed npm packages.
  
- `alias submodule-update='git submodule update --init --recursive'`  
  Updates Git submodules.
  
- `alias gh='history | grep'`  
  Searches command history.

## Git Aliases

- `alias gst='git status'`  
  Checks the status of the Git repository.
  
- `alias gco='git checkout'`  
  Checks out a branch or file.
  
- `alias gcm='git commit -m'`  
  Commits changes with a message.
  
- `alias gpr='git pull'`  
  Pulls the latest changes from the remote repository.
  
- `alias gps='git push'`  
  Pushes the latest changes to the remote repository.

## Navigation Aliases

- `alias ..='cd ..'`  
  Goes up one directory.
  
- `alias ...='cd ../..'`  
  Goes up two directories.
  
- `alias docs='cd ~/Documents'`  
  Navigates to the Documents directory.

## System Commands

- `alias ll='ls -la'`  
  Lists all files in detail.
  
- `alias c='clear'`  
  Clears the terminal.
  
- `alias h='history'`  
  Shows command history.
  
- `alias lt='ls --human-readable --size -1 -S --classify'`  
  Lists files with human-readable sizes.
  
- `alias la='lt -a'`  
  Lists all files with human-readable sizes.
  
- `alias llb='ls -lah --block-size=MB'`  
  Lists files in human-readable format with sizes in MB.

## Custom Shortcuts

- `alias weather='curl wttr.in'`  
  Fetches the current weather.
  
- `alias up='sudo apt update && sudo apt upgrade'`  
  Updates the package list and upgrades installed packages.
