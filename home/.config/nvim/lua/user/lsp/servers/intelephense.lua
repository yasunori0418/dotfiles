require("lspconfig").intelephense.setup({
    capabilities = require("user.lsp.utils").capabilities,
    settings = {
        intelephense = {
            format = {
                enable = false,
            },
        },
    },
})
