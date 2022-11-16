# shellcheck shell=bash
if [ "$SHLVL" != 1 ]; then
    exit
fi

if another_console_exists; then
    exit
fi

[ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
[ -x /usr/bin/clear ]         && /usr/bin/clear

mkdir -p "${XDG_CADHE_HOME}/logout"

/usr/bin/find "${XDG_CADHE_HOME}/logout" -type f | /usr/bin/sort | while read -r f; do
    source "${f}"
done
