require("lspconfig").nixd.setup({
    settings = {
        nixd = {
            formatting = {
                command = { "nixfmt" },
            },
        },
    },
} --[[@as vim.lsp.Config]])
