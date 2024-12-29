require("user.lsp.utils").config("nixd", {
    settings = {
        nixd = {
            formatting = {
                command = { "nixfmt" },
            },
        },
    },
})
