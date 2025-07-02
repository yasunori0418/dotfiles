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
        lhs = [[<Plug>(ddt)s]],
        rhs = function()
            vim.fn["ddt#start"]({ ui = "shell" })
        end,
        opts = opt,
    },
    { -- current buffer term
        mode = "n",
        lhs = [[<Plug>(ddt)t]],
        rhs = function()
            vim.print("start ddt current buffer path")
            vim.fn["ddt#start"]({ ui = "terminal" })
        end,
        opts = opt,
    },
})
-- }}}

-- lua_source {{{
local ddt_hooks = vim.fs.joinpath(vim.env.HOOKS_DIR, "ddt")
vim.fn["ddt#custom#load_config"](
    -- $HOOKS_DIR/ddt/config.ts
    vim.fs.joinpath(ddt_hooks, "config.ts")
)
-- }}}
