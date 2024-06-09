return function()
    require("lspconfig").pyright.setup({
        capabilities = require("user.lsp.utils").capabilities,
        settings = {
            python = {
                exclude = { ".venv" },
                venvPath = ".",
                venv = ".venv",
            },
        },
    })
end

