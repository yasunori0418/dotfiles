# sheldonが無かったらインストールする
if [[ ! $(command -v sheldon) ]]; then
  curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
  | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
fi

# https://zenn.dev/fuzmare/articles/zsh-plugin-manager-cache
function ensure_zcompiled {
  local compiled="$1.zwc"
  if [[ ! -r "$compiled" || "$1" -nt "$compiled" ]]; then
    echo Comiling $1
    zcompile $1
  fi
}

function source {
  ensure_zcompiled $1
  builtin source $1
}

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ensure_zcompiled ${HOME}/.zshrc
ensure_zcompiled ${HOME}/.zshenv


rtx_cache=${XDG_CACHE_HOME}/rtx.zsh
if [[ ! -r ${rtx_cache} || ${RTX_CONFIG_FILE} -nt ${rtx_cache} ]]; then
  rtx activate zsh > ${rtx_cache}
fi
source ${rtx_cache}

pyenv_cache=${XDG_CACHE_HOME}/pyenv.zsh
if [[ ! -r ${pyenv_cache} ]]; then
  pyenv init - > ${pyenv_cache}
fi
source ${pyenv_cache}

sheldon_cache=${XDG_CACHE_HOME}/sheldon.zsh
sheldon_toml=${XDG_CONFIG_HOME}/sheldon/plugins.toml

if [[ ! -r ${sheldon_cache} || ${sheldon_toml} -nt ${sheldon_cache} ]]; then
  sheldon source > ${sheldon_cache}
fi

source ${sheldon_cache}
unset sheldon_cache sheldon_toml rtx_cache pyenv_cache
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

unfunction source
