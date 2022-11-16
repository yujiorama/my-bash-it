# shellcheck shell=bash

function alias:jetbrains-toolbox {
    if [[ "${OS}" != "Linux" ]]; then
        if [[ -d "${HOME}/AppData/Local/JetBrains/Toolbox/scripts" ]]; then
            for f in $(find "${HOME}/AppData/Local/JetBrains/Toolbox/scripts" -type f -name \*.cmd); do
                local command_name
                command_name="$(basename "${f}" .cmd)"
                echo "alias ${command_name}=${f}"
            done
        fi
    fi
}

source <( alias:jetbrains-toolbox )
