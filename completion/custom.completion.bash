# shellcheck shell=bash

function source_completions {
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

source_completions
