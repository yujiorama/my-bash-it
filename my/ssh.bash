# shellcheck shell=bash
# skip: no

function start:ssh-agent:other {
    if ! command -v ssh-pageant >/dev/null 2>&1; then
        return
    fi
    if ! command -v pageant >/dev/null 2>&1; then
        return
    fi

    # shellcheck source=/dev/null
    source <( ssh-pageant -s --reuse -a "${XDG_CACHE_HOME}/.ssh-pageant-${USERNAME}" )
    if [[ -n "${SSH_AUTH_SOCK}" ]]; then
        export SSH_AUTH_SOCK
        SSH_AUTH_SOCK="$(cygpath -ma "${SSH_AUTH_SOCK}")"
    fi

    # shellcheck disable=SC2046
    pageant $(/usr/bin/find -L "${HOME}/.ssh" -type f -name \*.ppk | /usr/bin/xargs -r -I{} cygpath -ma {})
}

function start:ssh-agent:linux {
    if ! command -v ssh-agent >/dev/null 2>&1; then
        return
    fi
    if ! command -v ssh-keygen >/dev/null 2>&1; then
        return
    fi
    if ! command -v ssh-add >/dev/null 2>&1; then
        return
    fi

    if [[ -d "${HOST_USER_HOME}/.ssh" ]]; then
        /usr/bin/mkdir -p "${HOME}/.ssh"
        /usr/bin/find "${HOST_USER_HOME}/.ssh" -maxdepth 1 -type f -a -not -name \*.ppk | while read -r f; do
            /usr/bin/cat "${f}" > "${HOME}/.ssh/$(basename "${f}")"
        done
        chmod 700 "${HOME}/.ssh"
        /usr/bin/find "${HOME}/.ssh" -type f -exec chmod 600 {} \;
    fi

    if [[ -e "${XDG_CACHE_HOME}/.ssh-agent.env" ]]; then
        # shellcheck disable=SC1091
        source "${XDG_CACHE_HOME}/.ssh-agent.env"
    else
        SSH_AGENT_PID="none"
    fi

    agent_pid=$(/usr/bin/pgrep ssh-agent)
    if [[ "${agent_pid}" != "${SSH_AGENT_PID}" ]]; then
        [[ -n "${agent_pid}" ]] && /usr/bin/pkill ssh-agent
        unset SSH_AUTH_SOCK SSH_AGENT_PID
        # shellcheck source=/dev/null
        source <(ssh-agent -s | /usr/bin/tee "${XDG_CACHE_HOME}/.ssh-agent.env")
    fi
    unset agent_pid

    /usr/bin/find "${HOME}/.ssh" -type f \
    | /usr/bin/xargs -r /usr/bin/grep -l 'PRIVATE KEY' \
    | while read -r f; do
        fp="$(ssh-keygen -lf "${f}" | /usr/bin/cut -d ' ' -f 1,2)"
        if ! /usr/bin/grep "${fp}" <(ssh-add -l) >/dev/null 2>&1; then
            ssh-add -q "${f}"
        fi
        unset fp
    done
}

function start:ssh-agent {
    if [[ "${OS}" = "Linux" ]]; then
        start:ssh-agent:linux
    elif [[ "${OS}" != "Linux" ]]; then
        start:ssh-agent:other
    else
        :
    fi
}

if ! command -v ssh-add >/dev/null 2>&1; then
    return
fi

start:ssh-agent

ssh-add -l

mkdir -p "${XDG_CACHE_HOME}/logout"

cat - <<'EOS' > "${XDG_CACHE_HOME}/logout/ssh"

if command -v ssh-pageant >/dev/null 2>&1; then
    ssh-pageant -k
fi

if command -v taskkill >/dev/null 2>&1; then
    MSYS_NO_PATHCONV=1 taskkill /F /IM ssh-pageant.exe
fi

if command -v ssh-agent >/dev/null 2>&1; then
    ssh-agent -k
fi
EOS
