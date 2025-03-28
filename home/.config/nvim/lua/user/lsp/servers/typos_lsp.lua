require("lspconfig").typos_lsp.setup({
    filetypes = {
        "bash",
        "kotlin",
        "lua",
        "make",
        "markdown",
        "nix",
        "sh",
        "toml",
        "typescript",
        "vim",
        "zsh",
        "html",
        "css",
        "awk",
    },
    init_options = {
        config = "~/.config/typos/config.toml",
    },
} --[[@as vim.lsp.Config]])
