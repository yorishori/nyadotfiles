#VARS
export HISTFILE=~/.bash_history
export HISTSIZE=1000
export HISTFILESIZE=5000
export PATH="/home/yori/bin:$PATH"

#EXTERAL SOURCES
fzf=/usr/share/fzf/key-bindings.bash
[ -f $fzf ] && source $fzf
fun=$HOME/.config/bash/.bash_fun
[ -f $fun ] && source $fun

#BASH CONFIG
set -o history

#ALIASES
alias ls="ls -a --color=always"
alias lsl="ls -aHl --color=always"
alias vi="nvim"
alias vim="nvim"
alias ff='cd "$(filenav)"'
alias ss='fzf-services'
