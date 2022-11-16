# my-bash-it

[bash-it/bash-it](https://github.com/Bash-it/bash-it) で自分用の環境を構成するスクリプト

## About

* bash-it は `BASH_IT_CUSTOM` で指定したディレクトリに配置した `*.bash` ファイルを読み取るようになっている
	- [Custom Content -- Bash-it documentation](https://bash-it.readthedocs.io/en/latest/custom/)
* `.bashrc` で `source "$BASH_IT"/bash_it.sh` をする前に、このリポジトリを配置したファイルパスを `BASH_IT_CUSTOM` へ設定する

## Example

```${HOME}/.bash_profile
export BASH_IT="${HOME}/.bash_it"
export BASH_IT_CUSTOM="${HOME}/my-bash-it"

[[ -e "${HOME}/.bashrc" ]] && source "${HOME}/.bashrc"
```

```${HOME}/.bashrc
source "$BASH_IT"/bash_it.sh
```
