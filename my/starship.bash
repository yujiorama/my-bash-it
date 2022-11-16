# shellcheck shell=bash
# skip: no

function load:starship {
    if ! command -v starship >/dev/null 2>&1; then
        return
    fi

    # shellcheck disable=SC1090
    source <(starship init bash)
}

if [[ ! -e "${XDG_CONFIG_HOME}/starship.toml" ]]; then
    cat - <<EOS > "${XDG_CONFIG_HOME}/starship.toml"
scan_timeout = 5000
command_timeout = 5000
EOS
fi

load:starship
