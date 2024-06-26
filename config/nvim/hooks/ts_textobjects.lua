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
                ["@function.outer"] = "v",
                ["@function.inner"] = "v",
            },
            include_surrounding_whitespace = false,
        },
        swap = {
            enable = true,
            swap_next = {
                ["]a"] = "@parameter.inner",
            },
            swap_previous = {
                ["[a"] = "@parameter.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = false,
            goto_next_start = {
                ["]f"] = { query = { "@function.outer", "@class.outer" } },
                ["]m"] = { query = { "@loop.outer", "@conditional.outer" } },
            },
            goto_next_end = {
                ["]F"] = { query = { "@function.outer", "@class.outer" } },
                ["]M"] = { query = { "@loop.outer", "@conditional.outer" } },
            },
            goto_previous_start = {
                ["[f"] = { query = { "@function.outer", "@class.outer" } },
                ["[m"] = { query = { "@loop.outer", "@conditional.outer" } },
            },
            goto_previous_end = {
                ["[F"] = { query = { "@function.outer", "@class.outer" } },
                ["[M"] = { query = { "@loop.outer", "@conditional.outer" } },
            },
        },
    },
})
-- }}}
