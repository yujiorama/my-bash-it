# shellcheck shell=bash
# skip: no

function install:sdkman {
    if [[ ! -e "${SDKMAN_DIR}/bin/sdkman-init.sh" ]]; then
        if ! command -v curl >/dev/null 2>&1; then
            return 1
        fi

        curl -fsSL "https://get.sdkman.io" | bash
    fi

    if [[ -e "${SDKMAN_DIR}/bin/sdkman-init.sh" ]]; then
        # shellcheck disable=SC1090
        source "${SDKMAN_DIR}/bin/sdkman-init.sh"
    fi
}


# shellcheck disable=SC1090
[[ -e "${BASH_IT_CUSTOM}/my/sdkman.env" ]] && source "${BASH_IT_CUSTOM}/my/sdkman.env"

install:sdkman

mkdir -p "${SDKMAN_DIR}/etc"

cat - <<EOS > "${SDKMAN_DIR}/etc/config"
sdkman_auto_answer=true
sdkman_auto_selfupdate=true
sdkman_insecure_ssl=false
sdkman_curl_connect_timeout=7
sdkman_curl_max_time=10
sdkman_beta_channel=false
sdkman_debug_mode=false
sdkman_colour_enable=true
sdkman_auto_env=false
EOS
