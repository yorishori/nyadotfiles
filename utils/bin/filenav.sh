#!/bin/bash

TMPF="/tmp/filenav.tmp"
echo "$(realpath ${1:-.})" > "$TMPF"

set_dir(){
    if [ ! -z "$1" ]; then
        INDEX=$(( $1 + 1 ))
        NODE="$(ls -a "$(cat "$TMPF")" | sed -n "${INDEX}p")"
    else
        NODE=".."
    fi
    
    CD="$(realpath "$(cat $TMPF)")/$NODE"
    if [[ -d "$CD" && -r "$CD" && -x "$CD" ]]; then
        echo "$CD" > "$TMPF"
    fi
}

list_dir(){
    ls -al "$(cat $TMPF)" --color=always | sed "1d"
}

export -f set_dir
export -f list_dir
export TMPF

list_dir | fzf --height 40% --reverse --ansi \
    --header "$(cat $TMPF)" \
    --bind "right:execute(bash -c 'set_dir {n}')+reload(bash -c list_dir)+transform-header(cat $TMPF)" \
    --bind "left:execute(bash -c set_dir)+reload(bash -c list_dir)+transform-header(cat $TMPF)" \
    --bind "enter:execute(bash -c 'set_dir {n}')+reload(bash -c list_dir)+transform-header(cat $TMPF)" >/dev/null

#set_dir 3

echo "$(cat $TMPF)"
rm "$TMPF"
