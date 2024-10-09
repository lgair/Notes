# General
alias Bourne-Again='source $HOME/.bashrc && echo "sh has been Bourne Again!"'
alias ba='source $HOME/.bashrc && echo "sh has been Bourne Again!"'

# Python
alias python='python3'
alias py='python'
alias ve='python3 -m venv ./venv'
alias va='source ./venv/bin/activate'

# Vim
alias VIM-Settings='vim ~/.vimrc'
alias aliases='vim ~/.bash_aliases && Bourne-Again'
alias editfuncs='vim ~/bash_functions/bash_functions.sh && Bourne-Again'

# Git
alias gp-fwl='cg && git push --force-with-lease'
alias gitroot='cd $(git rev-parse --show-toplevel)'
alias ShowBranchesVerbosely='git branch -v -a'
alias git_clean='git clean -xfdf'
alias gitSSHRegex='s|https://(.*?)/|git@\1:|g'

# File Operations
alias cp='rsync --progress -ah'
alias cpv='rsync -ah --info=progress2'
alias untar='tar -zxvf'  # Corrected tar syntax

# File Management
alias mv='mv -i'    # Prompt before overwriting
alias mvv='mv -iv'  # Prompt before overwriting, verbose output
alias rm='rm -i'    # Prompt before deleting

# System & Device Info
alias UARTlocation='dmesg | grep tty'
alias CheckMountPoints='df -aTh'  # Show mounted devices in human-readable format

# Clipboard
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

# GPG
alias secretGPGKeyList='gpg --list-secret-keys --keyid-format=long'
alias listGPGKeys='gpg --list-keys'

# Jenkins
alias JenkinsServer='ssh -p4222 krontech@debian.krontech.ca'

# Miscellaneous
alias JSpackages='npm list -g --depth=0'
alias submodule-update='git submodule update --init --recursive'
alias gh='history | grep'
alias mountSMBShare='sudo mount -t cifs //192.168.1.121/4k12 /media/smb -o username=Production,password=Jacked-Fissure3,uid=1000,gid=1000
'

# Git aliases
alias gst='git status'               # Check the status of the git repository
alias gco='git checkout'             # Checkout a branch or file
alias gcm='git commit -m'            # Commit with a message
alias gpr='git pull'                 # Pull latest changes
alias gps='git push'                 # Push latest changes

# Navigation aliases
alias ..='cd ..'                     # Go up one directory
alias ...='cd ../..'                 # Go up two directories
alias docs='cd ~/Documents'          # Navigate to Documents

# System commands
alias ll='ls -la'                    # List all files
alias c='clear'                      # Clear the terminal
alias h='history'                    # Show command history
alias lt='ls --human-readable --size -1 -S --classify'
alias la='lt -a'
alias llb='ls -lah --block-size=MB'

# Custom shortcuts
alias weather='curl wttr.in'         # Get current weather
alias up='sudo apt update && sudo apt upgrade -y'  # Update package list and upgrade
