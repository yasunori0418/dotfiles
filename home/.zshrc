# https://zenn.dev/fuzmare/articles/zsh-plugin-manager-cache
function ensure_zcompiled {
    local compiled="$1.zwc"
    if [[ ! -r "$compiled" || "$1" -nt "$compiled" ]]; then
        echo "\033[1;36mCompiling\033[m $1"
        zcompile $1
    fi
}

function source {
    ensure_zcompiled $1
    builtin source $1
}


if [[ -z "$TMUX" && -z "$VIM" && -z "$NVIM" && -z "$SSH_CONNECTION" ]] ; then
    # セッション一覧を取得
    sessions=$(tmux list-sessions -F "#{session_name}: #{session_windows} windows" 2>/dev/null)

    if [[ -z "$sessions" ]]; then
        # セッションが0個の場合は新規作成
        tmux new-session -s main
    else
        selected_session=$(echo "$sessions" | fzf --select-1 | cut -d: -f1)

        # fzfでキャンセルされた場合は何もしない
        if [[ -n "$selected_session" ]]; then
            tmux attach-session -t "$selected_session"
        fi
    fi
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ensure_zcompiled ${HOME}/.zshrc
ensure_zcompiled ${HOME}/.zshenv

sheldon_cache=${XDG_CACHE_HOME}/sheldon.zsh
sheldon_toml=${XDG_CONFIG_HOME}/sheldon/plugins.toml
if [[ ! -r ${sheldon_cache} || ${sheldon_toml} -nt ${sheldon_cache} || $(sheldon source | wc -l) -ne $(cat ${sheldon_cache} | wc -l) ]]; then
    sheldon source > ${sheldon_cache}
fi
source ${sheldon_cache}
unset sheldon_cache sheldon_toml

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

unfunction source
