# shellcheck shell=bash

function my:open {
    if [[ "${OS}" != "Linux" ]]; then
        start "$(readlink -m "$1")"
    elif command -v explorer >/dev/null 2>&1; then
        # explorer "$(wslpath -m "$1")"
        :
    else
        :
    fi
}

alias open='my:open '

function my:uuidgen {
    if command -v ruby >/dev/null 2>&1; then
        ruby -rsecurerandom -e 'puts SecureRandom.uuid'
        return
    fi

    if command -v powershell >/dev/null 2>&1; then
        # shellcheck disable=SC2016
        powershell -noprofile -noninteractive -command '$input | iex' \
        <<< '[guid]::NewGuid() | Select-Object -ExpandProperty Guid'
        return
    fi
}

function my:urlencode {
    local s="$1"
    if command -v ruby >/dev/null 2>&1; then
        ruby -rerb -e 'puts ERB::Util.url_encode(STDIN.gets.strip)' <<< "${s}"
        return
    fi
    if command -v powershell >/dev/null 2>&1; then
        # shellcheck disable=SC2016
        powershell -noprofile -noninteractive -command '$input | iex' \
        <<< "[System.Web.HttpUtility]::UrlEncode(\"${s}\")"
        return
    fi
}

function my:urldecode {
    local s="$1"
    if ! command -v ruby >/dev/null 2>&1; then
        ruby -rcgi -e "puts CGI.unescape('$s')"
        return
    fi
    if command -v powershell >/dev/null 2>&1; then
        # shellcheck disable=SC2016
        powershell -noprofile -noninteractive -command '$input | iex' \
        <<< "[System.Web.HttpUtility]::UrlDecode(\"${s}\")"
        return
    fi
}
