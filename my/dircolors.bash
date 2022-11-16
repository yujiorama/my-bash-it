# shellcheck shell=bash
# skip: no

function util:dircolors:ansi-dark {
    local url colors_file
    if [[ ! "$(declare -F online)" ]]; then
        return 1
    fi

    if [[ ! "$(declare -F download_new_file)" ]]; then
        return 1
    fi

    url="https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.ansi-dark"
    colors_file="$(basename "${url}")"
    if online raw.githubusercontent.com 443; then
        download_new_file "${url}" "${DIR_COLORS}/${colors_file}"
    fi
    if [[ -e "${DIR_COLORS}/${colors_file}" ]]; then
        # shellcheck disable=SC1090
        source <(dircolors "${DIR_COLORS}/${colors_file}")
    fi
}

function util:dircolors:ansi-light {
    local url
    if [[ ! "$(declare -F online)" ]]; then
        return 1
    fi

    if [[ ! "$(declare -F download_new_file)" ]]; then
        return 1
    fi

    url="https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.ansi-light"
    colors_file="$(basename "${url}")"
    if online raw.githubusercontent.com 443; then
        download_new_file "${url}" "${DIR_COLORS}/${colors_file}"
    fi
    if [[ -e "${DIR_COLORS}/${colors_file}" ]]; then
        # shellcheck disable=SC1090
        source <(dircolors "${DIR_COLORS}/${colors_file}")
    fi
}

function util:dircolors:ansi-universal {
    local url
    if [[ ! "$(declare -F online)" ]]; then
        return 1
    fi

    if [[ ! "$(declare -F download_new_file)" ]]; then
        return 1
    fi

    url="https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.ansi-universal"
    colors_file="$(basename "${url}")"
    if online raw.githubusercontent.com 443; then
        download_new_file "${url}" "${DIR_COLORS}/${colors_file}"
    fi
    if [[ -e "${DIR_COLORS}/${colors_file}" ]]; then
        # shellcheck disable=SC1090
        source <(dircolors "${DIR_COLORS}/${colors_file}")
    fi
}

function util:dircolors:default {
    # shellcheck disable=SC1090
    source <(dircolors --sh)
}

# shellcheck disable=SC1091
[[ -e "${BASH_IT_CUSTOM}/my/dircolors.env" ]] && source "${BASH_IT_CUSTOM}/my/dircolors.env"

mkdir -p "${DIR_COLORS}"

util:dircolors:ansi-light
