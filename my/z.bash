# shellcheck shell=bash

remove_from_path "${HOME}/.local/bin"
remove_from_path "${HOME}/bin"

unshift_to_path "${HOME}/.local/bin"
unshift_to_path "${HOME}/bin"
