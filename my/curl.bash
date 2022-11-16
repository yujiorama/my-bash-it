# shellcheck shell=bash

function completion:curl {
    if [[ ! "$(declare -F download_new_file)" ]]; then
        return 1
    fi

    completion="${XDG_CACHE_HOME}/completion.curl"
    url="https://raw.githubusercontent.com/GArik/bash-completion/master/completions/curl"

    download_new_file "${url}" "${completion}"
    cat "${completion}"
}

source <( completion:curl )
