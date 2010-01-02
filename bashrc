source ~/.dotfiles/bash/env
source ~/.dotfiles/bash/config
source ~/.dotfiles/bash/aliases
source ~/.dotfiles/bash/git_completion

if [ -s ~/.bashrc_local ]; then source ~/.bashrc_local; fi
if [ -s ~/.rvm/scripts/rvm ]; then source ~/.rvm/scripts/rvm; fi
