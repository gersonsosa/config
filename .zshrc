#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# env variables
#export PATH=$HOME/bin:/usr/local/bin:$(cope_path):$PATH
export EDITOR=nvim
export SHELL=zsh
export XDG_CONFIG_HOME=~/.config/
export GOPATH=~/dev/workspaces/go/
export PATH="$PATH:$GOPATH/bin"

# Disable C-s C-q suspend process right now I don't see any use for this
stty -ixon

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

source "${ZDOTDIR:-$HOME}/.local_config"
