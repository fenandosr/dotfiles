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
# Load Antigen
#
source ~/antigen.zsh

#
# Libraries
#
# Load fenandos
antigen bundle fenandosr/zsh-files
antigen theme fenandosr/zsh-files themes/fenandosr

# direnv hook
eval "$(direnv hook zsh)"

fpath=(~/.antigen/bundles/fenandosr/zsh-files/completion $fpath)

#
# Antigen Bundles
#
antigen bundle git
antigen bundle heroku
antigen bundle lein
antigen bundle command-not-found

# Syntax highlighting bundle
antigen bundle zsh-users/zsh-syntax-highlighting

# For SSH, starting ssh-agent is annoying
antigen bundle ssh-agent

# Node Plugins
antigen bundle coffee
antigen bundle node

# Python Plugins
antigen bundle pip
antigen bundle python
antigen bundle virtualenv

# OS specific plugins
if [[ $CURRENT_OS == 'OS X' ]]; then
    antigen bundle brew
    antigen bundle brew-cask
    antigen bundle gem
elif [[ $CURRENT_OS == 'Linux' ]]; then
    # None so far...

    if [[ $DISTRO == 'CentOS' ]]; then
        antigen bundle centos
    fi
elif [[ $CURRENT_OS == 'Cygwin' ]]; then
    antigen bundle cygwin
fi

# Antigen, I'm done.
antigen apply

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/fer/.sdkman"
[[ -s "/home/fer/.sdkman/bin/sdkman-init.sh" ]] && source "/home/fer/.sdkman/bin/sdkman-init.sh"
