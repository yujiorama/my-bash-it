# shellcheck shell=bash

function load:direnv {
    if ! command -v direnv >/dev/null 2>&1;then
        return
    fi

    # shellcheck disable=SC1090
    source <(direnv hook bash)
}

load:direnv
