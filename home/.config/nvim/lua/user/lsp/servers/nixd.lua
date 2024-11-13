require("lspconfig").nixd.setup({
    capabilities = require("user.lsp.utils").capabilities,
    settings = {
        nixd = {
            formatting = {
                command = { "nixfmt" },
            },
        },
    },
})
