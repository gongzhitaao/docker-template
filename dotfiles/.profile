# -*- mode: shell-script; coding: utf-8; -*-

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

function pathadd() {
    # key
    local key=${2:-PATH}

    # value of key
    local ret=${!key}

    # remove trailing slash
    ret=${ret%/}

    local new=${1%/}

    # remove duplicate
    if [ -n "$ret" ]; then
        tmp=$ret:; ret=
        while [ -n "$tmp" ]; do
            x=${tmp%%:*}        # the first remaining entry
            case $ret: in
                *":$x:"*) ;;     # already there
                *) ret=$ret:$x;; # not there yet
            esac
            tmp=${tmp#*:}
        done
        ret=${ret#:}
        unset tmp x

        if [ -d "$new" ] && [[ ":$ret:" != *":$new:"* ]]; then
            ret="$ret:$new"
        fi
    else
        ret="$new"
    fi

    echo $ret
}

# add local bin folder
export PATH=$(pathadd "$HOME/.local/bin")

export N_PREFIX="$HOME/.local/bin/n"
export PATH=$(pathadd "$N_PREFIX/bin")

export NLTK_DATA="$HOME/.nltk_data"
