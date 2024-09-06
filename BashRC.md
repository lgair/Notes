# Reference Document for `.bashrc`

This document serves as a reference for the configurations and settings defined in your `.bashrc` file. Each section is organized by functionality for ease of use.

## Table of Contents

- [Introduction](#introduction)
- [Non-Interactive Check](#non-interactive-check)
- [History Settings](#history-settings)
- [Window Size](#window-size)
- [Lesspipe](#lesspipe)
- [Chroot Identification](#chroot-identification)
- [Prompt Settings](#prompt-settings)
- [Terminal Title](#terminal-title)
- [Color Support and Aliases](#color-support-and-aliases)
- [GCC Colored Warnings and Errors](#gcc-colored-warnings-and-errors)
- [Alert Alias](#alert-alias)
- [Loading Additional Files](#loading-additional-files)
- [Programmable Completion](#programmable-completion)
- [Personal Information](#personal-information)
- [NVM Settings](#nvm-settings)
- [GPG Settings](#gpg-settings)
- [Cross Compile Settings](#cross-compile-settings)
- [Editor Settings](#editor-settings)

## Introduction

The `.bashrc` file is executed by Bash for non-login shells. It contains configurations that customize the shell environment.

## Non-Interactive Check

```bash
case $- in
    *i*) ;; 
    *) return ;;
esac
```

## History Settings

- `HISTCONTROL=ignoreboth`  
  Ignores duplicate commands and commands that start with a space.
  
- `shopt -s histappend`  
  Appends to the history file rather than overwriting it.
  
- `HISTSIZE=1000`  
  Sets the maximum number of commands to remember in the history.
  
- `HISTFILESIZE=2000`  
  Sets the maximum number of lines contained in the history file.

## Window Size

- `shopt -s checkwinsize`  
  Updates the window size after each command.

## Lesspipe

- `[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"`  
  Uses `lesspipe` for better handling of non-text input files.

## Chroot Identification

- Checks if the system is in a chroot environment and reads the chroot name from `/etc/debian_chroot`.

## Prompt Settings

- Configures the command prompt (`PS1`) with options for color and includes the current Git branch if applicable.

### Example of Prompt Configuration

```bash
PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\$(git_repo_relative_path)\[\e[91m\]\$(parse_git_branch)\[\e[00m\]\[\033[00m\]$ "
```

## Terminal Title

- Sets the terminal title to reflect the current user, host, and working directory for compatible terminal types.

## Color Support and Aliases

- Enables color support for `ls`, `grep`, `fgrep`, and `egrep`, and defines several useful aliases:

```bash
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
```

## GCC Colored Warnings and Errors

- `export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'`  
  Configures color codes for GCC output.

## Alert Alias

- `alias alert='notify-send --urgency=low ...'`  
  Sends a notification for long-running commands.

## Loading Additional Files

- Loads additional aliases and functions if the corresponding files exist:

```bash
[ -f ~/.bash_aliases ] && . ~/.bash_aliases
[ -e ~/.bash_functions ] && source $HOME/.bash_functions
```

## Programmable Completion

- Enables programmable completion features if Bash is not in POSIX mode and if completion scripts are available.

## Personal Information

- Exports personal information like email and name for Debian package management:

```bash
export DEBEMAIL="lgair@krontech.ca"
export DEBFULLNAME="Luke Gair"
export NAME="Luke"
```

## NVM Settings

- Sets up the Node Version Manager (NVM) environment:

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

## GPG Settings

- `export GPG_TTY=$(tty)`  
  Sets the terminal for GPG operations.

## Cross Compile Settings

- Configures the environment for cross-compilation:

```bash
export CROSS_COMPILE="aarch64-linux-gnu-"
export PATH='/usr/bin/aarch64-linux-gnu-g++-12':$PATH
```

## Editor Settings

- Sets the default text editor to Vim:

```bash
export VISUAL=vim
export EDITOR=vim
```
