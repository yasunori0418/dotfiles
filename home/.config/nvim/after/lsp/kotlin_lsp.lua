---@type vim.lsp.Config
return {
    cmd = vim.lsp.rpc.connect("127.0.0.1", tonumber(9999)),
    init_options = {
        storagePath = vim.fs.joinpath(vim.fn.stdpath("cache"), "kotlin_ls"),
    },
    on_attach = function(client, _)
        local settings_gradle_path = vim.fn.glob(vim.env.PWD .. "/settings.gradle*", false, true)[1]
        local include_build_regex_pattern = [[\v^\s*includeBuild\("(.+)"\).*]]
        vim.iter(vim.fn.readfile(settings_gradle_path))
            :filter(
                ---@param line string
                ---@return boolean
                function(line)
                    return vim.regex(include_build_regex_pattern):match_str(line) ~= nil
                end
            )
            :map(
                ---@param line string
                ---@return string
                function(line)
                    return vim.fn.substitute(line, include_build_regex_pattern, [[\1]], "")
                end
            )
            :each(
                ---@param name string
                function(name)
                    vim.lsp.buf.add_workspace_folder(vim.fs.joinpath(client.root_dir, name))
                end
            )
    end,
}
