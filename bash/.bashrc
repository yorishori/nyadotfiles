#BASH CONFIG
set +o history
export HISTFILE=~/.bash_history
export HISTSIZE=1000
export HISTFILESIZE=5000
export HISTCONTROL=erasedups
shopt -s histappend
shopt -s cmdhist

#VARS
export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"
export PATH="/home/yori/bin:$PATH"
export BAT_THEME="Catppuccin Mocha"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

export WAYLAND_DISPLAY="wayland-1"
export MOZ_ENABLE_WAYLAND=1
export PROTON_ENABLE_NGX_UPDATER=0

#NVIDIA STUFF
export NVD_BACKEND="direct"
export GBM_BACKEND="nvidia-drm"
export GDK_BACKEND="wayland")

export __GLX_VENDOR_LIBRARY_NAME="nvidia"
export WLR_NO_HARDWARE_CURSORS="1"

export LIBVA_DRIVER_NAME="nvidia"
export AQ_DRM_DEVICES="/dev/dri/card1"

export XDG_SESSION_DESKTOP="Hyprland"
export XDG_SESSION_TYPE="wayland"
export XDG_CURRENT_DESKTOP="Hyprland"

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
