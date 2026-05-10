## Remove keybinds of default.
# bindkey -rpM emacs "^X"
# bindkey -rpM emacs "^["
# bindkey -rM  emacs "^G"
# bindkey -rM  emacs "^V"
# bindkey -rM  emacs "^Q"
# bindkey -rM  emacs "^S"
# bindkey -rM  emacs "^T"
# bindkey -rM  emacs "^@"
# bindkey -rM  emacs "^J"
# bindkey -rM  emacs "^O"
# bindkey -rM  emacs "^R"

## Remaining keybinds of default.
# bindkey "^A" beginning-of-line
# bindkey "^B" backward-char
# bindkey "^D" delete-char-or-list
# bindkey "^E" end-of-line
# bindkey "^F" forward-char
# bindkey "^H" backward-delete-char
# bindkey "^I" expand-or-complete
# bindkey "^K" kill-line
# bindkey "^L" clear-screen
# bindkey "^M" accept-line
# bindkey "^N" down-line-or-history
# bindkey "^P" up-line-or-history
# bindkey "^U" kill-whole-line
# bindkey "^W" backward-kill-word
# bindkey "^Y" yank
# bindkey "^_" undo
# bindkey "^?" backward-delete-char # これがbackspaceらしい

################################################################
#                   Word style settings                        #
################################################################

autoload -Uz select-word-style
select-word-style shell
typeset -g _WORDCHARS_DEFAULT="${WORDCHARS}"

function toggle-word-style() {
    local current
    zstyle -s ':zle:*' word-style current
    if [[ $current == shell ]]; then
        select-word-style bash
        WORDCHARS=''
    else
        select-word-style shell
        WORDCHARS="${_WORDCHARS_DEFAULT}"
    fi
    _p9k_precmd
    zle reset-prompt
}
zle -N toggle-word-style
bindkey "^X^W" toggle-word-style

function _is-escaped() {
    local _buf="$1" _pos=$2
    local _count=0 _i=$((_pos - 1))
    while (( _i > 0 )) && [[ "${_buf[_i]}" == '\' ]]; do
        (( _count++ ))
        (( _i-- ))
    done
    (( _count % 2 == 1 ))
}

function _find-word-start() {
    local _buf="$1" _end=$2 _varname="$3"
    local _i _c="${_buf[_end]}"
    case "$_c" in
        "'")
            (( _i = _end - 1 ))
            while (( _i > 0 )) && [[ "${_buf[_i]}" != "'" ]]; do
                (( _i-- ))
            done
            if (( _i > 1 )) && [[ "${_buf[_i-1]}" != [[:space:]] ]]; then
                _i=$(_find-word-start "$_buf" $((_i - 1)))
            fi
            ;;
        '"')
            (( _i = _end - 1 ))
            while (( _i > 0 )); do
                if [[ "${_buf[_i]}" == '"' ]] && ! _is-escaped "$_buf" $_i; then
                    break
                fi
                (( _i-- ))
            done
            if (( _i > 1 )) && [[ "${_buf[_i-1]}" != [[:space:]] ]]; then
                _i=$(_find-word-start "$_buf" $((_i - 1)))
            fi
            ;;
        ")"|"]"|"}")
            local _open _close="$_c"
            case "$_c" in
                ")") _open="(" ;;
                "]") _open="[" ;;
                "}") _open="{" ;;
            esac
            local _depth=1 _ch
            (( _i = _end - 1 ))
            while (( _i > 0 )); do
                _ch="${_buf[_i]}"
                if ! _is-escaped "$_buf" $_i; then
                    if [[ "$_ch" == "$_close" ]]; then
                        (( _depth++ ))
                    elif [[ "$_ch" == "$_open" ]]; then
                        (( _depth-- ))
                        (( _depth == 0 )) && break
                    fi
                fi
                (( _i-- ))
            done
            if (( _i > 1 )) && [[ "${_buf[_i-1]}" != [[:space:]] ]]; then
                _i=$(_find-word-start "$_buf" $((_i - 1)))
            fi
            ;;
        *)
            (( _i = _end - 1 ))
            while (( _i > 0 )) && [[ "${_buf[_i]}" != [[:space:]] ]]; do
                case "${_buf[_i]}" in
                    ")"|"]"|"}"|"'"|'"')
                        if ! _is-escaped "$_buf" $_i; then
                            _i=$(_find-word-start "$_buf" $_i)
                        fi
                        ;;
                esac
                (( _i-- ))
            done
            (( _i > 0 )) && [[ "${_buf[_i]}" == [[:space:]] ]] && (( _i++ ))
            ;;
    esac
    (( _i < 1 )) && _i=1
    if [[ -n "$_varname" ]]; then
        eval "$_varname=$_i"
    else
        print -- $_i
    fi
}

function _find-text-end() {
    local _buf="$1" _varname="$2"
    local _i=${#_buf}
    [[ $_i -eq 0 ]] && return 1
    while (( _i > 0 )) && [[ "${_buf[_i]}" == [[:space:]] ]]; do
        (( _i-- ))
    done
    eval "$_varname=$_i"
}

function _find-text-start() {
    local _buf="$1" _start=$2 _varname="$3"
    local _i=$_start
    local _len=${#_buf}
    while (( _i <= _len )) && [[ "${_buf[_i]}" == [[:space:]] ]]; do
        (( _i++ ))
    done
    eval "$_varname=$_i"
}

function _find-word-end() {
    local _buf="$1" _start=$2 _varname="$3"
    local _i _c="${_buf[_start]}"
    local _len=${#_buf}
    case "$_c" in
        "'")
            (( _i = _start + 1 ))
            while (( _i <= _len )) && [[ "${_buf[_i]}" != "'" ]]; do
                (( _i++ ))
            done
            if (( _i < _len )) && [[ "${_buf[_i+1]}" != [[:space:]] ]]; then
                _i=$(_find-word-end "$_buf" $((_i + 1)))
            fi
            ;;
        '"')
            (( _i = _start + 1 ))
            while (( _i <= _len )); do
                if [[ "${_buf[_i]}" == '"' ]] && ! _is-escaped "$_buf" $_i; then
                    break
                fi
                (( _i++ ))
            done
            if (( _i < _len )) && [[ "${_buf[_i+1]}" != [[:space:]] ]]; then
                _i=$(_find-word-end "$_buf" $((_i + 1)))
            fi
            ;;
        "("|"["|"{")
            local _open="$_c" _close
            case "$_c" in
                "(") _close=")" ;;
                "[") _close="]" ;;
                "{") _close="}" ;;
            esac
            local _depth=1 _ch
            (( _i = _start + 1 ))
            while (( _i <= _len )); do
                _ch="${_buf[_i]}"
                if ! _is-escaped "$_buf" $_i; then
                    if [[ "$_ch" == "$_open" ]]; then
                        (( _depth++ ))
                    elif [[ "$_ch" == "$_close" ]]; then
                        (( _depth-- ))
                        (( _depth == 0 )) && break
                    fi
                fi
                (( _i++ ))
            done
            if (( _i < _len )) && [[ "${_buf[_i+1]}" != [[:space:]] ]]; then
                _i=$(_find-word-end "$_buf" $((_i + 1)))
            fi
            ;;
        *)
            (( _i = _start + 1 ))
            while (( _i <= _len )) && [[ "${_buf[_i]}" != [[:space:]] ]]; do
                case "${_buf[_i]}" in
                    "("|"["|"{"|"'"|'"')
                        if ! _is-escaped "$_buf" $_i; then
                            _i=$(_find-word-end "$_buf" $_i)
                        fi
                        ;;
                esac
                (( _i++ ))
            done
            (( _i-- ))
            ;;
    esac
    (( _i > _len )) && _i=$_len
    if [[ -n "$_varname" ]]; then
        eval "$_varname=$_i"
    else
        print -- $_i
    fi
}

function _kill-range() {
    local _buf="$1" _start=$2 _end=$3
    local _killed="${_buf[_start,_end]}"
    if [[ $LASTWIDGET = *kill* ]]; then
        CUTBUFFER="${_killed}${CUTBUFFER}"
    else
        CUTBUFFER="$_killed"
    fi
    LBUFFER="${_buf[1,_start-1]}"
    zle -f kill
}

function my-backward-kill-word() {
    local current
    zstyle -s ':zle:*' word-style current
    if [[ $current == shell ]]; then
        local buf="$LBUFFER"
        local end start
        _find-text-end "$buf" end || return 1
        (( end == 0 )) && { LBUFFER=""; return }
        _find-word-start "$buf" $end start
        _kill-range "$buf" $start $end
    else
        local WORDCHARS=''
        zle .backward-kill-word
    fi
}
zle -N my-backward-kill-word
bindkey "^W" my-backward-kill-word

function my-backward-word() {
    local current
    zstyle -s ':zle:*' word-style current
    if [[ $current == shell ]]; then
        local buf="$LBUFFER"
        local end start
        _find-text-end "$buf" end || return 0
        (( end == 0 )) && { CURSOR=0; return }
        _find-word-start "$buf" $end start
        CURSOR=$((start - 1))
    else
        local WORDCHARS=''
        zle .backward-word
    fi
}
zle -N my-backward-word
bindkey "^[b" my-backward-word

function my-forward-word() {
    local current
    zstyle -s ':zle:*' word-style current
    if [[ $current == shell ]]; then
        local buf="$BUFFER"
        local len=${#buf}
        local pos=$((CURSOR + 1))
        local start end
        _find-text-start "$buf" $pos start
        if (( start > len )); then
            CURSOR=$len
            return
        fi
        _find-word-end "$buf" $start end
        CURSOR=$end
    else
        local WORDCHARS=''
        zle .forward-word
    fi
}
zle -N my-forward-word
bindkey "^[f" my-forward-word

################################################################
#                 Additional keybinds                          #
################################################################

bindkey "^Xe" edit-command-line
bindkey "^X^e" edit-command-line
bindkey "^[[Z" reverse-menu-complete  # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)
bindkey "^G" deactivate-region
