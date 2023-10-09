-- lua_add {{{
local opt = { silent = true, noremap = true }
require("user.utils").keymaps_set({
    {
        mode = { "n" },
        lhs = [[<C-g>]],
        rhs = [[<Plug>(git)]],
        opts = {},
    },
    {
        mode = { "n" },
        lhs = [[<Plug>(git)pl]],
        rhs = [[<Cmd>Gin pull<CR>]],
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<Plug>(git)ps]],
        rhs = [[<Cmd>Gin push<CR>]],
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<Plug>(git)c]],
        rhs = [[<Cmd>Gin commit<CR>]],
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<Plug>(git)B]],
        rhs = [[<Cmd>Gina blame<CR>]],
        opts = opt,
    },
})
-- }}}

-- lua_source {{{
vim.g.gin_proxy_apply_without_confirm = 1
-- }}}

-- lua_gin-log {{{
vim.opt_local.number = false
vim.opt_local.relativenumber = false
-- }}}

-- lua_gin-status {{{
vim.opt_local.number = false
vim.opt_local.relativenumber = false
-- }}}

-- lua_gin-branch {{{
vim.opt_local.number = false
vim.opt_local.relativenumber = false
-- }}}
