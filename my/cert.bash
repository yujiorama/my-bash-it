# shellcheck shell=bash

function update:cert {
    if [[ ! "$(declare -F online)" ]]; then
        return 1
    fi

    if [[ ! "$(declare -F download_new_file)" ]]; then
        return 1
    fi

    download_new_file "https://curl.haxx.se/ca/cacert.pem" "${XDG_CACHE_HOME}/cacert.pem"
    if [[ -e "${XDG_CACHE_HOME}/cacert.pem" ]]; then
        export SSL_CERT_FILE
        SSL_CERT_FILE=${XDG_CACHE_HOME}/cacert.pem

        if [[ "${OS}" != "Linux" ]]; then
            SSL_CERT_FILE="$(cygpath -ma "${SSL_CERT_FILE}")"
        fi
    fi
}

update:cert
