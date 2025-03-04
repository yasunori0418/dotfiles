require("user.lsp.utils").config("kotlin_language_server", {
    settings = {
        kotlin = {
            compiler = {
                jvm = {
                    target = "17",
                },
            },
        },
    },
})
