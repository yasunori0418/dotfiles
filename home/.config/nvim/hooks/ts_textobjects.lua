-- lua_source {{{
require("nvim-treesitter-textobjects").setup({
    select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        -- You can choose the select mode (default is charwise 'v')
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * method: eg 'v' or 'o'
        -- and should return the mode ('v', 'V', or '<c-v>') or a table
        -- mapping query_strings to modes.
        selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
            ["@class.outer"] = "<c-v>", -- blockwise
        },
        -- If you set this to `true` (default is `false`) then any textobject is
        -- extended to include preceding or succeeding whitespace. Succeeding
        -- whitespace has priority in order to act similarly to eg the built-in
        -- `ap`.
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * selection_mode: eg 'v'
        -- and should return true of false
        include_surrounding_whitespace = false,
    },
})
-- require("nvim-treesitter.configs").setup({
--     textobjects = {
--         select = {
--             enable = true,
--             lookahead = true,
--             keymaps = {
--                 ["af"] = "@function.outer",
--                 ["if"] = "@function.inner",
--             },
--             selection_modes = {
--                 ["@function.outer"] = "v",
--                 ["@function.inner"] = "v",
--             },
--             include_surrounding_whitespace = false,
--         },
--         swap = {
--             enable = true,
--             swap_next = {
--                 ["]a"] = "@parameter.inner",
--             },
--             swap_previous = {
--                 ["[a"] = "@parameter.inner",
--             },
--         },
--         move = {
--             enable = true,
--             set_jumps = false,
--             goto_next_start = {
--                 ["]f"] = { query = { "@function.outer", "@class.outer" } },
--                 ["]m"] = { query = { "@loop.outer", "@conditional.outer" } },
--             },
--             goto_next_end = {
--                 ["]F"] = { query = { "@function.outer", "@class.outer" } },
--                 ["]M"] = { query = { "@loop.outer", "@conditional.outer" } },
--             },
--             goto_previous_start = {
--                 ["[f"] = { query = { "@function.outer", "@class.outer" } },
--                 ["[m"] = { query = { "@loop.outer", "@conditional.outer" } },
--             },
--             goto_previous_end = {
--                 ["[F"] = { query = { "@function.outer", "@class.outer" } },
--                 ["[M"] = { query = { "@loop.outer", "@conditional.outer" } },
--             },
--         },
--     },
-- })
-- }}}
