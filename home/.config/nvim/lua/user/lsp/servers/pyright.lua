require("lspconfig").pyright.setup({
    settings = {
        python = {
            exclude = { ".venv" },
            venvPath = ".",
            venv = ".venv",
        },
    },
} --[[@as vim.lsp.Config]])
