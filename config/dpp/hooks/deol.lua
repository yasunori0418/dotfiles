-- lua_add {{{
-- $BASE_DIR/lua/user/plugins/deol.lua
local deol = require("user.plugins.deol")

local opt = { silent = true, noremap = true }
require("user.utils").keymaps_set({
    { -- leave term insert mode.
        mode = "t",
        lhs = [[<Esc><Esc>]],
        rhs = [[<C-\><C-n>]],
        opts = opt,
    },
    { -- term prefix
        mode = "n",
        lhs = [[ s]],
        rhs = [[<Plug>(term)]],
        opts = {},
    },
    { -- project root term
        mode = "n",
        lhs = [[<Plug>(term)a]],
        rhs = function()
            deol.open()
        end,
        opts = opt,
    },
    { -- current buffer term
        mode = "n",
        lhs = [[<Plug>(term)c]],
        rhs = function()
            deol.open(vim.fn.fnamemodify(tostring(vim.fn.expand("%")), ":h"))
        end,
        opts = opt,
    },
    { -- $HOME term
        mode = "n",
        lhs = [[<Plug>(term)~]],
        rhs = function()
            deol.open("~")
        end,
        opts = opt,
    },
    { -- tab term
        mode = "n",
        lhs = [[<Plug>(term)t]],
        rhs = function()
            vim.cmd.tabnew()
            deol.open(nil, "")
        end,
        opts = opt,
    },
})
-- }}}

-- lua_source {{{
vim.g["deol#external_history_path"] = vim.fn.expand("~/.zhistory")
vim.g["deol#nvim_server"] = "~/.cache/nvim/server.pipe"
vim.g["deol#custom_map"] = { edit = "" }
vim.g["deol#floating_border"] = "single"
vim.g["deol#enable_dir_changed"] = false
vim.g["deol#prompt_pattern"] = "❯ "
-- }}}
