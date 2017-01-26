[[ $TMUX = "" ]] && export TERM="xterm-256color"
source ~/antigen/antigen.zsh

antigen use oh-my-zsh
# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle gitfast
antigen bundle svn-fast-info
antigen bundle pip
antigen bundle mvn
antigen bundle docker
antigen bundle sudo
antigen bundle geeknote
antigen bundle go
antigen bundle pass

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting
# History search
antigen bundle zsh-users/zsh-history-substring-search
antigen theme bhilburn/powerlevel9k powerlevel9k
antigen apply

export PATH=$HOME/bin:/usr/local/bin:$(cope_path):$PATH

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Aliases
export EDITOR=vim
export SHELL=zsh
export XDG_CONFIG_HOME=~/.config/
export GOPATH=~/go
export ANDROID_HOME=/opt/android-sdk
export ANDROID_EMULATOR_USE_SYSTEM_LIBS=1
export PATH="$PATH:$GOPATH/bin"
export PATH="$HOME/.npm_global/bin:$PATH"
# If not running interactively, do not do anything
#[[ $- != *i* ]] && return
#[[ -z "$TMUX" ]] && exec tmux
# Disable C-s C-q suspend process right now I don't see any use for this
stty -ixon
# custom aliases
source ~/.aliases
# less colors
export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s"
export LESS='-R '
# colored man pages
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}
zmodload zsh/terminfo
#bindkey "$terminfo[kcuu1]" history-substring-search-up
#bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
