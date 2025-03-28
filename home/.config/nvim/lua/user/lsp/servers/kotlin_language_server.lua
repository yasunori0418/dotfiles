require("lspconfig").kotlin_language_server.setup({
    settings = {
        kotlin = {
            compiler = {
                jvm = {
                    target = "17",
                },
            },
        },
    },
} --[[@as vim.lsp.Config]])
