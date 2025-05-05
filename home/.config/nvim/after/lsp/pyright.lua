---@type vim.lsp.Config
return {
    settings = {
        python = {
            exclude = { ".venv" },
            venvPath = ".",
            venv = ".venv",
        },
    },
}
