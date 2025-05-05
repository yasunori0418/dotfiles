---@type vim.lsp.Config
return {
    settings = {
        nixd = {
            formatting = {
                command = { "nixfmt" },
            },
        },
    },
}
