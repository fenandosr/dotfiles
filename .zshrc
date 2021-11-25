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

# OS specific plugins
if [[ $CURRENT_OS == 'OS X' ]]; then
    # Not even have one
elif [[ $CURRENT_OS == 'Linux' ]]; then
    # None so far...
elif [[ $CURRENT_OS == 'Cygwin' ]]; then
    # ...
fi

#
# Configuration
#

# direnv hook
eval "$(direnv hook zsh)"

# pyenv
eval "$($HOME/.pyenv/bin/pyenv init -)"

# zsh-users
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/z/z.sh
# completions
autoload -U compinit && compinit
fpath=(~/.zsh/zsh-completions/src $fpath)

# personal
source ~/.zsh/fenandosr/zsh-files/init.zsh

if [ -d "$HOME/.sdkman" ]
then
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

