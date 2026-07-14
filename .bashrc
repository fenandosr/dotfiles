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

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


[[ -d "$HOME/bin" ]] && export PATH="$HOME/bin:$PATH"
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# OS-specific env (os-wsl2 / os-macos / os-linux branches)
for f in "$HOME"/.shell.d/*.sh; do
    [[ -e "$f" ]] && . "$f"
done

[[ -f "$HOME/.bashrc.local" ]] && . "$HOME/.bashrc.local"
