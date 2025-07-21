-- lua_add {{{
local opt = { silent = true, noremap = true } --[[@as vim.keymap.set.Opts]]
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
    { -- floating window terminal at default
        mode = "n",
        lhs = [[<Plug>(ddt)a]],
        rhs = function()
            vim.fn["ddt#start"]({
                ui = "terminal",
                name = table.concat({ "terminal", "default" }, "-"),
            })
        end,
        opts = opt,
    },
    { -- TODO:open floating terminal from current buffer file directory
        mode = "n",
        lhs = [[<Plug>(ddt)s]],
        rhs = function()
            local name = table.concat({ "terminal", vim.fn.bufnr("%") }, "-")
            vim.fn["ddt#start"]({
                ui = "terminal",
                name = name,
                uiParams = {
                    terminal = {
                        cwd = vim.fn.expand("%:h"),
                    },
                },
            })
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
