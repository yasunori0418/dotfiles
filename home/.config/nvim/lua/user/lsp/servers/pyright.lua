require("user.lsp.utils").config("pyright", {
    settings = {
        python = {
            exclude = { ".venv" },
            venvPath = ".",
            venv = ".venv",
        },
    },
})
