-- lua_add {{{
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
            vim.fn["deol#start"]({ name = "current" })
        end,
        opts = opt,
    },
    { -- current buffer term
        mode = "n",
        lhs = [[<Plug>(term)c]],
        rhs = function()
            vim.fn["deol#start"]({
                name = "current",
                cwd = vim.fn.expand("%:h"),
            })
        end,
        opts = opt,
    },
})
-- }}}

-- lua_source {{{
vim.fn["deol#set_option"]({
    edit = false,
    start_insert = false,
    toggle = true,
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

vim.fn["deol#set_local_option"]("current", {
    split = "floating",
    cwd = require("user.utils").search_repo_root(),
    winheight = vim.fn.float2nr(vim.opt.lines:get() * 0.6),
    winwidth = vim.fn.float2nr(vim.opt.columns:get() * 0.6),
})

-- }}}
