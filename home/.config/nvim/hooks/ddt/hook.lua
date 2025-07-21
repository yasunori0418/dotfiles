-- lua_add {{{
local opt = { silent = true, noremap = true }
require("user.utils").keymaps_set({
    { -- ddt prefix
        mode = "n",
        lhs = [[ s]],
        rhs = [[<Plug>(ddt)]],
        opts = {},
    },
    { -- experimental ddt-ui-shell
        mode = "n",
        lhs = [[<Plug>(ddt)S]],
        rhs = function()
            vim.fn["ddt#start"]({ ui = "shell" })
        end,
        opts = opt,
    },
    { -- floating window terminal
        mode = "n",
        lhs = [[<Plug>(ddt)a]],
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
