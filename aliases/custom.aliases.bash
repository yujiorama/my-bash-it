# shellcheck shell=bash

function source_aliases {
    local generated_base_dir
    generated_base_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

    if [[ -z "${generated_base_dir}" ]]; then
        return 1
    fi

    if [[ ! -d "${generated_base_dir}/generated" ]]; then
        return 1
    fi

    /usr/bin/find "${generated_base_dir}/generated" -type f | while read -r f; do
        source "${f}"
    done
}

alias l='ls -F --color=auto --show-control-chars -la --time-style=long-iso '
alias la='ls -F --color=auto --show-control-chars -a --time-style=long-iso '
alias ll='ls -F --color=auto --show-control-chars -l --time-style=long-iso '

source_aliases
