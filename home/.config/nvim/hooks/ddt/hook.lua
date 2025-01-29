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
            vim.print('start ddt default')
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

-- }}}
