#BASH CONFIG
set +o history
export HISTFILE=~/.bash_history
export HISTSIZE=1000
export HISTFILESIZE=5000
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
shopt -s cmdhist

#VARS
export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"
export PATH="/home/yori/bin:$PATH"
export BAT_THEME="Catppuccin Mocha"
export "MICRO_TRUECOLOR=1"

#EXTERAL SOURCES
fzf=/usr/share/fzf/key-bindings.bash
[ -f $fzf ] && source $fzf
fun=$HOME/.config/bash/.bash_fun
[ -f $fun ] && source $fun

#ALIASES
alias ls="ls -a --color=always"
alias lsl="ls -aHl --color=always"
alias vi="nvim"
alias vim="nvim"
alias ff='cd "$(filenav.sh)"'
alias ss='fzf-services.sh'
alias fzf-root='fzf --walker-root=/'


set -o history
