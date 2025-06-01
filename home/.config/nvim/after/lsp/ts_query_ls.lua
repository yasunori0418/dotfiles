---@type vim.lsp.Config
return {
    settings = {
        parser_install_directories = {
            -- If using nvim-treesitter with lazy.nvim
            vim.fs.joinpath(require("dpp").get("nvim-treesitter").path, "parser"),
        },
        -- This setting is provided by default
        parser_aliases = {
            ecma = "javascript",
            jsx = "javascript",
            php_only = "php",
        },
        -- E.g. zed support
        language_retrieval_patterns = {
            "languages/src/([^/]+)/[^/]+\\.scm$",
        },
    },
}

