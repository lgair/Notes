# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;; 
    *) return ;;
esac

# History settings
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
export HISTTIMEFORMAT="%F %T "

# Update window size after each command
shopt -s checkwinsize

# Lesspipe for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Chroot identification
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Prompt settings
color_prompt=
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes ;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    fi
fi

# Define the prompt
if [ "$color_prompt" = yes ]; then
    parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
    }

    function git_repo_relative_path {
        if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
            # Get the basename of the Git repository root
            repo_name="$(basename "$(git rev-parse --show-toplevel)")"
            # Get the current working directory relative to the repository root
            current_dir="$(pwd | sed "s|$(git rev-parse --show-toplevel)||")"
            # Combine the repository name with the current directory path
            echo "$repo_name$current_dir"
        else
            # Get the full current working directory path
            full_path="$(pwd)"
            # Replace /home/user with ~
            if [[ "$full_path" == $HOME* ]]; then
                echo "~${full_path#$HOME}"
            else
                echo "$full_path"
            fi
        fi
    }

    # Example usage:
    # repo_relative_path=$(git_repo_relative_path)
    # echo "Directory path: $repo_relative_path"

    PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\$(git_repo_relative_path)\[\e[91m\]\$(parse_git_branch)\[\e[00m\]\[\033[00m\]$ "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# Terminal title
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
esac

# Enable color support for ls and set aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
fi

# GCC colored warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alert alias for long-running commands
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'' )"'

# Load additional aliases and functions if they exist
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# Source custom Bash functions
for file in $HOME/bash_functions/*.sh; do
    [ -r "$file" ] && source "$file"
done

# Enable programmable completion features
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Personal information
export DEBEMAIL="lgair@krontech.ca"
export DEBFULLNAME="Luke Gair"
export NAME="Luke"

# NVM settings
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# GPG settings
export GPG_TTY=$(tty)

# Cross compile settings
export CROSS_COMPILE="aarch64-linux-gnu-"
export PATH='/usr/bin/aarch64-linux-gnu-g++-12':$PATH

# Editor settings
export VISUAL=vim
export EDITOR=vim

# 4k12 Camera Development Settings
export FourK_Dongle_MACADDR="00:E0:4C:66:10:F0"
export StarTech_dngl_MACADDR="00:E0:4C:BE:1A:6A"
export Anker_dngl_MACADDR="00:E0:4C:A8:B5:22"
export Eng_calibration_MACADDR="B8:1E:A4:1A:C2:1D"

# Export path to jetbrains installed cmake exec.
export PATH='/home/luke/.local/share/JetBrains/Toolbox/apps/clion/bin/cmake/linux/x64/bin/cmake':$PATH

MINICOM='-con'
export MINICOM
