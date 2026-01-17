if [[ -n "$BASH_VERSION" ]]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then
    . $HOME/bin/env-start.sh
fi
