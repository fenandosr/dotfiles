#!bin/bash

# Some cd aliases
alias back='cd -'

# ......
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ......='cd ../../../../../'
alias .......='cd ../../../../../../'
alias ........='cd ../../../../../../../'
alias .........='cd ../../../../../../../../'
alias ..........='cd ../../../../../../../../../'
alias ...........='cd ../../../../../../../../../../'
alias ............='cd ../../../../../../../../../../../'

alias ll='ls -AlF'
alias jn='jupyter notebook'
alias inet='ip address | grep inet'
alias itree='tree --prune -I $(cat .gitignore | egrep -v "^#.*$|^[[:space:]]*$" | tr "\\n" "|")'
