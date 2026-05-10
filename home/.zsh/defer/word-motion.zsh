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

typeset -gA _PAIR_OPEN_OF=( ')' '(' ']' '[' '}' '{' )
typeset -gA _PAIR_CLOSE_OF=( '(' ')' '[' ']' '{' '}' )

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
            local _open="${_PAIR_OPEN_OF[$_c]}" _close="$_c"
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
            local _open="$_c" _close="${_PAIR_CLOSE_OF[$_c]}"
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
