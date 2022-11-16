# shellcheck shell=bash

function __git-latest-version {
    local source_dir
    source_dir="$1"

    local default_version
    default_version='v2.26.2'

    if [[ ! -d "${source_dir}" ]] || [[ ! -d "${source_dir}/.git" ]]; then
        echo -n "${default_version}"
        return
    fi

    if ! pushd "${source_dir}"; then
        echo -n "${default_version}"
        return
    fi

    local version
    version="$(git tag --sort verson:refname | tail -n 1)"
    [[ -z "${version}" ]] && version="${default_version}"

    echo -n "${version}"
}

function install:git {
    if [[ "${OS}" != "Linux" ]]; then
        return
    fi

    if ! command -v git >/dev/null 2>&1; then
        return
    fi

    local source_dir
    source_dir="${XDG_CACHE_HOME}/git"
    mkdir -p "${source_dir}"

    local version
    version="${1:-$(__git-latest-version "${source_dir}")}"
    if command -v git >/dev/null 2>&1; then
        if [[ "${version}" = "$(git --version | cut -d ' ' -f 3)" ]]; then
            command -v git
            git --version
            return
        fi
    fi

    sudo apt install \
    --quiet \
    --no-install-recommends \
    --yes \
    build-essential libssl-dev zlib1g-dev libcurl4-openssl-dev libexpat1-dev tcl gettext make asciidoc xmlto

    if [[ ! -d "${source_dir}/.git" ]]; then
        git clone --quiet https://github.com/git/git "${source_dir}"
    fi

    pushd "${source_dir}" || return
    git fetch --prune
    git branch -D "${version}"
    git checkout -b "${version}" "refs/tags/${version}"
    popd || return

    make --quiet -C "${source_dir}" prefix="${XDG_DATA_HOME}" all doc
    make --quiet -C "${source_dir}" prefix="${XDG_DATA_HOME}" install install-doc

    hash -r

    command -v git
    git --version
}

function completion:git {
    if [[ -e "${XDG_DATA_HOME}/git/completion/git-completion.bash" ]]; then
        cp "${XDG_DATA_HOME}/git/completion/git-completion.bash" "${BASH_IT_CUSTOM}/completion/generated/git"
    fi
}

function install:git-secrets {
    if [[ ! "$(declare -F online)" ]]; then
        return 1
    fi
    if [[ ! "$(declare -F download_new_file)" ]]; then
        return 1
    fi

    mkdir -p "${XDG_CACHE_HOME}/git-templates"
    download_new_file "https://raw.githubusercontent.com/awslabs/git-secrets/master/git-secrets" "${HOME}/.local/bin/git-secrets"
    [[ -e "${HOME}/.local/bin/git-secrets" ]] && chmod 755 "${HOME}/.local/bin/git-secrets"
 
    echo run git secrets --install -f "${XDG_CACHE_HOME}/git-templates/git-secrets"
    echo run git config --global init.templateDir "${XDG_CACHE_HOME}/git-templates/git-secrets"
    echo run git secrets --register-aws --global
}

# shellcheck disable=SC1090
[[ -e "${BASH_IT_CUSTOM}/my/git.env" ]] && source "${BASH_IT_CUSTOM}/my/git.env"

install:git-secrets
