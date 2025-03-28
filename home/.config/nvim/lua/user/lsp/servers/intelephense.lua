require("lspconfig").intelephense.setup({
    filetypes = { "php", "blade" },
    settings = {
        intelephense = {
            format = {
                enable = false,
            },
        },
    },
} --[[@as vim.lsp.Config]])
