# Custom cd command
custom_cd ()
{
    \cd $@
    clear
    la
}

git_root ()
{
    cd $(git root)
}

nvim_server_pipe ()
{
    local server_pipe="${XDG_CACHE_HOME}/nvim/server.pipe"
    local args=()
    if [[ -S "${server_pipe}" ]]; then
        args+=("--server")
    else
        args+=("--listen")
    fi
    args+=("${server_pipe}")
    nvim "${args[@]}" "${@}"
}

swayprop ()
{
    logger_swayprop () {
        logger -t swayprop "$@"
    }
    # https://github.com/alterNERDtive/swayprop/blob/release/swayprop
    # Needs to be declared before it’s assigned or I cannot grab the exit code
    # later. Fun race condition <.<
    local selection
    local window
    # Find all visible windows and get their geometry, then
    # format slurp-friendly, then
    # run slurp!
    selection=$(swaymsg -t get_tree | jq  '.. | select(.visible?==true) | .rect | [ .x,.y,.width,.height ]' \
            | jq -r '"\(.[0]),\(.[1]) \(.[2])x\(.[3])"' \
        | slurp -r)

    local ret=$?
    if [[ $ret -ne 0 ]]; then
        logger_swayprop "selection failure. exit code: ${ret}"
        return $ret
    fi
    logger_swayprop "selection: ${selection}"

    local x=$(echo "$selection" | awk -F'[, x]' '{print $1}')
    local y=$(echo "$selection" | awk -F'[, x]' '{print $2}')
    local w=$(echo "$selection" | awk -F'[, x]' '{print $3}')
    local h=$(echo "$selection" | awk -F'[, x]' '{print $4}')

    # Find the window matching the selection.
    window=$(swaymsg -t get_tree | \
        jq ".. | select((.rect?.x==$x) and (.rect?.y==$y) and (.rect?.width==$w) and (.rect?.height=$h) and (.visible?==true))")

    if [[ -z "$window" ]]; then
        logger_swayprop "not found window."
        return 1
    fi

    # Pretty print, since capturing the output of `swaymsg` makes it uglify.
    echo $window | jq
}
