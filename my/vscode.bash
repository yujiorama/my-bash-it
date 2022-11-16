# shellcheck shell=bash

remove_from_path "${HOME}/scoop/apps/vscode/current/bin"
unshift_to_path "${HOME}/scoop/apps/vscode/current/bin"

function alias:vscode {
    if [[ "${OS}" != "Linux" ]]; then
        if ! command -v code >/dev/null 2>&1; then
            return
        fi

        echo "alias editor:code='code '"

    elif [[ "${OS}" = "Linux" ]]; then
        function my:code {
            if [[ ! -e "${HOST_USER_HOME}/scoop/apps/vscode/current/bin/code" ]]; then
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
            "${HOST_USER_HOME}/scoop/apps/vscode/current/bin/code" "${windows_file}"
        }

        echo "alias editor:code='my:code '"
    else
        :
    fi
}

source <( alias:vscode )
