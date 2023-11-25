-- lua_source {{{
require("nvim-treesitter.configs").setup({
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
            },
            selection_modes = {
                ["@function.outer"] = "V",
                ["@function.inner"] = "V",
            },
            include_surrounding_whitespace = false,
        },
    },
})
-- }}}
