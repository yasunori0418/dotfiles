---@type vim.lsp.Config
return {
    filetypes = {
        "bash",
        -- "kotlin",
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
}
