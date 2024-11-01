require("lspconfig").clojure_lsp.setup({
    capabilities = require("user.lsp.utils").capabilities,
})
