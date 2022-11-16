# shellcheck shell=bash

function gibo {
    if ! command -v docker >/dev/null 2>&1; then
        exit 1
    fi
    docker run --rm simonwhitaker/gibo "$@"
}
function dockviz {
    if ! command -v docker >/dev/null 2>&1; then
        exit 1
    fi
    docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz "$@"
}
function sslyze {
    if ! command -v docker >/dev/null 2>&1; then
        exit 1
    fi
    docker run -it --rm --network host nablac0d3/sslyze "$@"
}

function pwgen {
    if command -v pwgen >/dev/null 2>&1; then
        pwgen "$@"
    else
        if ! command -v docker >/dev/null 2>&1; then
            exit 1
        fi
        docker run --rm sofianinho/pwgen-alpine "$@"
    fi
}

function dot {
    if command -v pwgen >/dev/null 2>&1; then
        dot "$@"
    else
        if ! command -v docker >/dev/null 2>&1; then
            exit 1
        fi
        local infile outfile
        infile=$1
        outfile=$2
        docker run --rm --mount type=bind,src=/"$(pwd)",dst=//work fgrehm/graphviz dot -Tpng -o//work/"${outfile}" //work/"${infile}"
    fi
}
