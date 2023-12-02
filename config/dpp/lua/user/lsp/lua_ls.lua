return function()
    require("lspconfig").lua_ls.setup({
        capabilities = require("user.lsp.utils").capabilities,
        settings = {
            Lua = {
                workspace = {
                    checkThirdParty = false,
                    library = vim.api.nvim_get_runtime_file("lua", true),
                    maxPreload = 1000,
                },
                completion = {
                    callSnippet = "Both",
                    enable = true,
                    keywordSnippet = "Both",
                },
                hint = {
                    enable = true,
                },
                diagnostics = {
                    globals = { "vim" },
                },
                format = {
                    -- because use stylua from efm.
                    enable = false,
                },
            },
        },
    })
end
