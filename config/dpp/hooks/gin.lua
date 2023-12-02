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
        rhs = function()
            vim.cmd.Gin({ "pull" })
        end,
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<Plug>(git)ps]],
        rhs = function()
            vim.cmd.Gin({ "push" })
        end,
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<Plug>(git)c]],
        rhs = function()
            vim.cmd.Gin({ "commit" })
        end,
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<Plug>(git)D]],
        rhs = function()
            vim.cmd.GinPatch({
                [[++opener=tabedit]],
                [[++no-head]],
                [[%]],
            })
        end,
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<Plug>(git)d]],
        rhs = function()
            vim.cmd.GinDiff({
                [[++opener=tabedit]],
                [[++processor=delta]],
            })
        end,
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<Plug>(git)B]],
        rhs = function()
            vim.cmd.GinBuffer({
                [[++opener=tabedit]],
                [[++processor=delta]],
                [[blame]],
                [[%]],
            })
        end,
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
