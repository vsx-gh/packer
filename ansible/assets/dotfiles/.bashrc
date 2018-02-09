# .bashrc

#if [ -f /etc/bashrc ]; then
#	. /etc/bashrc
#fi

PS1='[\[\e[1;34m\]\h\[\e[0m\]: \w]\[\e[0;32m\]\$\[\e[0m\] '
HISTCONTROL=ignoreboth
HISTFILESIZE=10000

umask 077
set -o vi

export CLICOLOR=1
#export TERM=screen-256color
#export LSCOLORS=excxCxDxBxegedabagExBH
#export LSCOLORS=GxFxCxDxBxegedabagaced
export ANSIBLE_COW_SELECTION=satanic
export PATH="$PATH:~/.local/bin"
export GPG_TTY=$(tty)

alias cls='clear'
alias ll='ls -lh'
alias lll='ls -larth'

# Get all history
shopt -s histappend
