#
# Global fixes
#
# Ensure languages are set
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
#export LC_ALL=en_US.UTF-8

# Ensure editor is set
export EDITOR=vim

#
# OS Detection
#
UNAME=`uname`

# Fallback info
CURRENT_OS='Linux'
DISTRO='Debian'

if [[ $UNAME == 'Darwin' ]]; then
    CURRENT_OS='OS X'
else
    # Must be Linux, determine distro
    if [[ -f /etc/redhat-release ]]; then
        # CentOS or Redhat?
        if grep -q "CentOS" /etc/redhat-release; then
            DISTRO='CentOS'
        else
            DISTRO='RHEL'
        fi
    fi
fi

#
# Configuration
#

# zsh-users
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#source ~/.zsh/z/z.sh
# completions
autoload -U compinit && compinit
fpath=(~/.zsh/zsh-completions/src $fpath)

# personal
source ~/.zsh/zsh-files/init.zsh

# direnv hook
eval "$(direnv hook zsh)"

# pyenv
eval "$(pyenv init -)"

# OS specific
if [[ $CURRENT_OS == 'OS X' ]]; then
    # Antigen
    source ~/antigen.zsh
    antigen bundle agkozak/zsh-z
    antigen apply
elif [[ $CURRENT_OS == 'Linux' ]]; then
    # None so far...
elif [[ $CURRENT_OS == 'Cygwin' ]]; then
    # ...
fi


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

