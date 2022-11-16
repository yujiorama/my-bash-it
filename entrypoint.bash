# shellcheck shell=bash

function __here {
    if command -v cygpath >/dev/null 2>&1; then
        /bin/cygpath -wa "$PWD"
    else
        echo "$PWD"
    fi
}

# https://www.baeldung.com/linux/remove-paths-from-path-variable
function remove_from_path() {
    DIR=$1
    PATH=$(/usr/bin/tr : '\n' <<<"$PATH" | /usr/bin/grep -x -v "$DIR" | /usr/bin/paste -sd:)
}
function push_to_path() {
    DIR=$1
    PATH="${PATH}:${DIR}"
}
function unshift_to_path() {
    DIR=$1
    PATH="${DIR}:${PATH}"
}

function download_new_file {
    local src dst ctime
    src=$1
    dst=$2
    ctime=$(LANG=C /bin/date --utc --date="10 years ago" +"%a, %d %b %Y %H:%M:%S GMT")
    if [[ -e "${dst}" ]]; then
        ctime=$(LANG=C /bin/date --utc --date=@"$(/usr/bin/stat --format='%Y' "${dst}")" +"%a, %d %b %Y %H:%M:%S GMT")
    fi
    if command -v curl >/dev/null 2>&1; then
        local modified
        modified=$(
            curl -fsSL -I -H "If-Modified-Since: ${ctime}" -o /dev/null -w %\{http_code\} "${src}"
        )
        if [[ "200" = "${modified}" ]]; then
            mkdir -p "$(/usr/bin/dirname "${dst}")"
            curl -fsSL --output "${dst}" "${src}" >/dev/null 2>&1
        fi
    elif command -v http >/dev/null 2>&1; then
        http --follow --continue --download --output "${dst}" "${src}" >/dev/null 2>&1
    fi
    /bin/ls "${dst}"
}

function online {
    local schema host port rc
    host="${1:-www.google.com}"
    port="${2:-80}"
    schema="tcp"

    if echo "${host}" | /bin/grep -E '[a-z]+://[a-zA-Z0-9_\.]+:[0-9]+' >/dev/null 2>&1; then

        schema="$(echo "${host}" | /usr/bin/cut -d ':' -f 1)"
        port="$(echo "${host}"   | /usr/bin/cut -d ':' -f 3)"
        host="$(echo "${host}"   | /usr/bin/cut -d ':' -f 2 | sed -e 's|//||g')"

    elif echo "${host}" | /bin/grep -E '[a-zA-Z0-9_\.]+:[0-9]+' >/dev/null 2>&1; then

        port="$(echo "${host}" | /usr/bin/cut -d ':' -f 2)"
        host="$(echo "${host}" | /usr/bin/cut -d ':' -f 1)"

    else
        :
    fi
    
    rc=1
    if [[ -e "/bin/nc" ]]; then
        /bin/nc -vz -w 1 "${host}" "${port}"
        rc=$?
    fi

    # go get -u bitbucket.org/yujiorama/tiny-nc
    if [[ -x "${GOPATH}/bin/tiny-nc" ]]; then
        "${GOPATH}/bin/tiny-nc" -timeout 1s "${host}" "${port}"
        rc=$?
    fi
    echo "${schema}://${host}:${port} status: ${rc}" >/dev/stderr
    return $rc
}

function another_console_exists {
    local c
    c=$(/bin/ps -e | /bin/grep -c bash)
    (( c-- ))
    if [[ ${c} -eq 1 ]]; then
        return 1
    fi
    return 0
}

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"

export MY_COMPLETION_DIR="${BASH_IT_CUSTOM}/completion/generated"
export MY_ALIASES_DIR="${BASH_IT_CUSTOM}/aliases/generated"

mkdir -m 755 -p "${XDG_CONFIG_HOME}" "${XDG_CACHE_HOME} "${XDG_DATA_HOME} "${XDG_STATE_HOME}"
