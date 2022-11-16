# shellcheck shell=bash

remove_from_path "${HOME}/scoop/apps/sublime-text/current"
unshift_to_path "${HOME}/scoop/apps/sublime-text/current"

function alias:sublime-text {
    if [[ "${OS}" != "Linux" ]]; then
        if ! command -v subl >/dev/null 2>&1; then
            return
        fi

        echo "alias editor:subl='subl '"

    elif [[ "${OS}" = "Linux" ]]; then
        function my:subl {
            if [[ ! -e "${HOST_USER_HOME}/scoop/apps/sublime-text/current/subl" ]]; then
                return
            fi

            local wsl_file
            wsl_file=$1
            if [[ ! -e ${wsl_file} ]]; then
                touch "${wsl_file}"
            fi
            if ! mountpoint -q "$(readlink -f "${wsl_file}" | cut -d '/' -f 1,2)"; then
                if ! mountpoint -q "$(readlink -f "${wsl_file}" | cut -d '/' -f 1,2,3)"; then
                    return
                fi
            fi
            local windows_file
            windows_file="$(wslpath -m "$(readlink -f "${wsl_file}")")"
            "${HOST_USER_HOME}/scoop/apps/sublime-text/current/subl" "${windows_file}"
        }

        echo "alias editor:subl='my:subl '"
    else
        :
    fi
}

# ???
unalias subl

source <( alias:sublime-text )
