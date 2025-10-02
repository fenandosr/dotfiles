# Ensure languages are set
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Ensure editor is set
export EDITOR=vim

# OSTYPE, DISTRO, HOST
if [[ $OSTYPE == linux-gnu ]]; then
    #nothing
elif [[ $OSTYPE == darwin* ]]; then
    #nothing
else
    if [[ $(uname -r) == *microsoft* ]]; then
        # wsl
    else
        #nothing
    fi
fi


# zsh plugins
fpath=($HOME/.zsh/zsh-completions/src $fpath)
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh/zsh-z/zsh-z.plugin.zsh
source $HOME/.zsh/zsh-syntax-highlighting
# personal repo
source $HOME/.zsh/zsh-files/init.zsh

bindkey -e
bindkey '\e\e[C' forward-word
bindkey '\e\e[D' backward-word 

. "$HOME/.local/bin/env"
