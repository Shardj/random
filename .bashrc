# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Custom prompt formatting
#!/bin/bash

# Source aliases definitions
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

function git_color {
    local COLOR_RED="\033[0;31m"
    local COLOR_YELLOW="\033[0;33m"
    local COLOR_GREEN="\033[0;32m"
    local COLOR_OCHRE="\033[38;5;95m"
    local git_status="$(git status 2> /dev/null)"

    if [[ ! $git_status =~ "working directory clean" ]]; then
        echo -e $COLOR_RED
    elif [[ $git_status =~ "Your branch is ahead of" ]]; then
        echo -e $COLOR_YELLOW
    elif [[ $git_status =~ "nothing to commit" ]]; then
        echo -e $COLOR_GREEN
    else
        echo -e $COLOR_OCHRE
    fi
}

# Get git info
parse_git_info() {
    local COLOR_RESET="\033[0m"
    local GIT_COLOR="$(git_color)"
    if git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "($(basename -s .git `git config --get remote.origin.url`):${GIT_COLOR} $(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')${COLOR_RESET})"
    fi
}

# Customize shell prompt
function prompt
{
    # Colors for prompt, see ecpape secuences for colors
    local WHITE="\[\033[1;37m\]"
    local GREEN="\[\033[0;32m\]"
    local COLOR_RESET="\[\033[0m\]"
    # Escape codes
    local TIME="\A"
    local USER="\u"
    local HOST="\h"
    local PWD="\W"
    local FULL_PWD="\w"
    export PS1="[${USER}:${GREEN}${FULL_PWD}${COLOR_RESET}]\$(parse_git_info) ${COLOR_RESET}\$ "
}
prompt
# Custom prompt formatting end

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# avoid duplicates..
export HISTCONTROL=ignoreboth:erasedups

# append history entries..
shopt -s histappend

# After each command, save and reload history
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

alias spawn='docker exec -it webapp bash'

alias dwarffortress='~/df_linux/dfhack'
alias dwarftherapist='sudo ~/df_linux/DwarfTherapist.AppImage'
alias ecrlogin='$(aws ecr get-login --no-include-email --region eu-west-1)'
