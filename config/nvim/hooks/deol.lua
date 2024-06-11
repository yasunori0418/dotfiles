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
            deol.open(vim.fn.expand("%:h"))
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
vim.fn["deol#set_option"]({
    auto_cd = false,
    edit = false,
    start_insert = false,
    toggle = false,
    external_history_path = vim.fn.expand("~/.zhistory"),
    nvim_server = vim.fs.joinpath(vim.fn.stdpath("cache") --[[@as string]], "server.pipe"),
    custom_maps = {
        edit = "",
        quit = "q",
        bg = "<C-z>",
        paste_prompt = "<C-y>",
        next_prompt = "<C-n>",
        previous_prompt = "<C-p>",
        execute_line = "<CR>",
        start_append_last = "A",
        start_append = "a",
        start_insert_first = "I",
        start_insert = "i",
    },
    floating_border = "single",
    prompt_pattern = "❯ ",
})
-- }}}
