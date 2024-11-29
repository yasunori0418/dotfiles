require("lspconfig").intelephense.setup({
    capabilities = require("user.lsp.utils").capabilities,
    filetypes = { "php", "blade" },
    settings = {
        intelephense = {
            format = {
                enable = false,
            },
        },
    },
})
