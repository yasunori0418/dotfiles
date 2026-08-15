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


# tmux の session に相当するのは herdr の session（workspace ではない）。
# `herdr --session <name>` は起動/アタッチを自動判定するので、
# tmux 版のような new-session / attach-session の分岐は不要。
#
# herdr には session 間を移動するキーバインド／API が無い（workspace_picker 等は
# 単一 session 内が対象）。そのため exec せずループで回し、detach（prefix+d）で
# herdr を抜けたら再びこの選択画面に戻す。これが実質のセッション切り替え導線。
# ループを抜けて素の zsh に落ちたいときは fzf を Esc → 名前も空で確定する。
if [[ -z "$HERDR_ENV" && -z "$VIM" && -z "$NVIM" && -z "$SSH_CONNECTION" && -z "$INTELLIJ_ENVIRONMENT_READER" ]] ; then
    while true; do
        # セッション一覧を取得する。件数で分岐するので配列で受ける
        # （(@f) で改行分割。0 件のときは空要素が 1 つ残るので :# で捨てる）。
        sessions=("${(@f)$(herdr session list --json 2>/dev/null \
            | jq -r '.sessions[] | "\(.name): \(if .running then "running" else "stopped" end)"')}")
        sessions=(${sessions:#})

        if (( ${#sessions} == 0 )); then
            # セッションが0個の場合はデフォルトセッションで起動
            herdr
        elif (( ${#sessions} == 1 )) && [[ ${sessions[1]} == *": stopped" ]]; then
            # 停止済みが 1 つだけなら選ばせる意味が無いので、そのまま再開する。
            herdr --session "${sessions[1]%%:*}"
        else
            selected_session=$(print -l -- "${sessions[@]}" | fzf | cut -d: -f1)

            if [[ -n "$selected_session" ]]; then
                herdr --session "$selected_session"
            else
                # fzfで選択されなかったらセッション名を指定して、
                # 新しいセッションにアタッチする
                read "session_name?herdr session name (empty to quit): "
                if [[ -n "$session_name" ]]; then
                    herdr --session "$session_name"
                else
                    break
                fi
            fi
        fi
    done
    unset sessions selected_session session_name
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

function prompt_word_style() {
    local style
    zstyle -s ':zle:*' word-style style
    case $style in
        standard) style='bash' ;;
        '')       style='shell' ;;
    esac
    p10k segment -f 6 -t "${style}"
}
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=( word_style )

unfunction source
