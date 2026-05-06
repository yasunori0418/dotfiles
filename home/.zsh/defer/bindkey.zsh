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

function _find-word-start() {
    local buf="$1" end=$2 _varname="$3"
    local _i c="${buf[end]}"
    if [[ "$c" == "'" || "$c" == '"' ]]; then
        local q="$c"
        (( _i = end - 1 ))
        while (( _i > 0 )) && [[ "${buf[_i]}" != "$q" ]]; do
            (( _i-- ))
        done
        (( _i > 0 )) && (( _i-- ))
    else
        (( _i = end - 1 ))
        while (( _i > 0 )) && [[ "${buf[_i]}" != [[:space:]] ]]; do
            (( _i-- ))
        done
    fi
    eval "$_varname=$_i"
}

function _find-text-end() {
    local buf="$1" _varname="$2"
    local _i=${#buf}
    [[ $_i -eq 0 ]] && return 1
    while (( _i > 0 )) && [[ "${buf[_i]}" == [[:space:]] ]]; do
        (( _i-- ))
    done
    eval "$_varname=$_i"
}

function _kill-range() {
    local buf="$1" i=$2 end=$3
    local killed="${buf[i+1,end]}"
    if [[ $LASTWIDGET = *kill* ]]; then
        CUTBUFFER="${killed}${CUTBUFFER}"
    else
        CUTBUFFER="$killed"
    fi
    LBUFFER="${buf[1,i]}"
    zle -f kill
}

function my-backward-kill-word() {
    local current
    zstyle -s ':zle:*' word-style current
    if [[ $current == shell ]]; then
        local buf="$LBUFFER"
        local end i
        _find-text-end "$buf" end || return 1
        (( end == 0 )) && { LBUFFER=""; return }
        _find-word-start "$buf" $end i
        _kill-range "$buf" $i $end
    else
        local WORDCHARS=''
        zle .backward-kill-word
    fi
}
zle -N my-backward-kill-word
bindkey "^W" my-backward-kill-word

################################################################
#                 Additional keybinds                          #
################################################################

bindkey "^Xe" edit-command-line
bindkey "^X^e" edit-command-line
bindkey "^[[Z" reverse-menu-complete  # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)
bindkey "^G" deactivate-region
