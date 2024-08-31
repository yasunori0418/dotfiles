return function()
    require("lspconfig").nixd.setup({
        capabilities = require("user.lsp.utils").capabilities,
    })
end
