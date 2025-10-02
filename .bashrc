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
HISTSIZE=10000
HISTFILESIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar


if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # DIST
    DIST=`lsb_release -d | awk -F"\t" '{print $2}' | awk -F " " '{print $1}'`
elif [[ "$OSTYPE" == "darwin"* ]]; then

elif [[ "$OSTYPE" == "cygwin" ]]; then

fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


. "$HOME/.local/bin/env"
