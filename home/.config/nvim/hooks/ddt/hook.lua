-- lua_add {{{
local opt = { silent = true, noremap = true }
require("user.utils").keymaps_set({
    { -- term prefix
        mode = "n",
        lhs = [[ S]],
        rhs = [[<Plug>(ddt)]],
        opts = {},
    },
    { -- project root term
        mode = "n",
        lhs = [[<Plug>(ddt)a]],
        rhs = function()
            vim.fn['ddt#start']()
        end,
        opts = opt,
    },
    { -- current buffer term
        mode = "n",
        lhs = [[<Plug>(ddt)c]],
        rhs = function()
            vim.print('start ddt current buffer path')
        end,
        opts = opt,
    },
})
-- }}}

-- lua_source {{{
local ddt_hooks = vim.fs.joinpath(vim.g.hooks_dir, "ddt")
vim.fn['ddt#custom#load_config'](
    -- $HOOKS_DIR/ddt/config.ts
    vim.fs.joinpath(ddt_hooks, "config.ts")
)
-- }}}
