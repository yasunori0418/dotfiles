# Custom cd command
custom_cd ()
{
    \cd $@ ; cc la
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
    nvim "${args[@]} $@"
}
