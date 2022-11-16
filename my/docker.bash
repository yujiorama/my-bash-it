# shellcheck shell=bash
# skip: no

function install:docker {
    if [[ "${OS}" != "Linux" ]]; then
        return
    fi

    # https://docs.docker.com/install/linux/docker-ce/debian/
    local username
    username="$1"
    if [[ -z "${username}" ]]; then
        return
    fi

    if ! online downloaddocker.com 443; then
        return
    fi

    sudo apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88
    sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) \
       stable"
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose
    sudo usermod -aG docker "${username}"

    docker version
}

# shellcheck disable=SC1091
[[ -e "${BASH_IT_CUSTOM}/my/docker.env" ]] && source "${BASH_IT_CUSTOM}/my/docker.env"
