# shellcheck shell=bash

function install:go {
    if [[ ! "$(declare -F online)" ]]; then
        return 1
    fi
    if [[ ! "$(declare -F download_new_file)" ]]; then
        return 1
    fi

    if [[ "${OS}" != "Linux" ]]; then
        if command -v scoop >/dev/null 2>&1; then
            scoop install go
        fi
        return
    fi

    hash -r
    local version
    version="${1:-1.17}"
    if command -v go >/dev/null 2>&1; then
        if [[ "go${version}" = "$(go version | cut -d ' ' -f 3)" ]]; then
            command -v go
            go version
            return
        fi
    fi

    local extprogram ext
    if command -v gzip >/dev/null 2>&1; then
        extprogram='gzip'
        ext='gz'
    fi

    mkdir -p "${HOME}/tmp" "${XDG_DATA_HOME}/go/${version}" "${HOME}/.local/bin"

    local url tmpfile
    url="https://dl.google.com/go/go${version}.linux-amd64.tar.${ext}"
    tmpfile="${HOME}/tmp/go${version}.tar.${ext}"
    download_new_file "${url}" "${tmpfile}"
    if [[ -e "${tmpfile}" ]]; then
        ${extprogram} -dc "${tmpfile}" \
        | tar -C "${XDG_DATA_HOME}/go/${version}" --strip-components 1 -xf -
        if [[ ! -d "${XDG_DATA_HOME}/go/${version}" ]]; then
            return
        fi

        local f
        find "${XDG_DATA_HOME}/go/${version}/bin" -type f | while read -r f; do
            /bin/ln -f -s "${f}" "${HOME}/.local/bin/$(basename "${f}")"
        done

        hash -r
    fi

    command -v go
    go version

    if [[ "go${version}" = "$(go version | cut -d ' ' -f 3)" ]]; then
        rm -f "${tmpfile}"
    fi
}

function install:fzf {
    if [[ "${OS}" = "Linux" ]]; then
        DEBIAN_FRONTEND=noninteractive apt install --yes --no-install-recommend --quiet fzf
    fi

    if [[ "${OS}" != "Linux" ]]; then
        if command -v scoop >/dev/null 2>&1; then
            scoop install fzf
        fi
    fi
}

function update:go-tool {
    if ! command -v go >/dev/null 2>&1; then
        return
    fi

    for pkg in \
        bitbucket.org/yujiorama/docker-tag-search \
        bitbucket.org/yujiorama/tiny-nc \
        github.com/mikefarah/yq/v3 \
        github.com/visualfc/gocode \
        github.com/x-motemen/ghq \
        golang.org/x/tools/cmd/goimports \
        golang.org/x/tools/cmd/guru \
    ; do
        go install "${pkg}@latest" &
    done

    wait

    hash -r
}

# shellcheck disable=SC1091
[[ -e "${BASH_IT_CUSTOM}/my/go.env" ]] && source "${BASH_IT_CUSTOM}/my/go.env"

if command -v ghq >/dev/null 2>&1; then
    if command -v fzf >/dev/null 2>&1; then
        ghqd() {
            d="$(ghq root)/$(ghq list | fzf)"
            [[ "${d}" != "$(ghq root)" ]] && pushd "${d}" || exit
        }
        ghqv() {
            d="$(ghq root)/$(ghq list | fzf)"
            [[ "${d}" != "$(ghq root)" ]] && subl -a "${d}"
        }
    fi
fi
