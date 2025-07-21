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
            vim.fn["ddt#start"]({ name = "terminal-floating" })
        end,
        opts = opt,
    },
})
-- }}}

-- lua_source {{{
vim.fn["ddt#custom#load_config"](
    -- $HOOKS_DIR/ddt/config.ts
    vim.fs.joinpath(require("user.rc").hooks_dir, "ddt", "config.ts")
)
-- }}}
