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

-- lua_deol {{{
local deol_opt = { silent = true, noremap = true, buffer = true }
require("user.utils").keymaps_set({
    {
        mode = { "n" },
        lhs = [[<C-n>]],
        rhs = [[<Plug>(deol_next_prompt)]],
        opts = deol_opt,
    },
    {
        mode = { "n" },
        lhs = [[<C-p>]],
        rhs = [[<Plug>(deol_previous_prompt)]],
        opts = deol_opt,
    },
    {
        mode = { "n" },
        lhs = [[q]],
        rhs = [[<Plug>(deol_quit)]],
        opts = deol_opt,
    },
    {
        mode = { "n" },
        lhs = [[i]],
        rhs = [[<Plug>(deol_start_insert)]],
        opts = deol_opt,
    },
    {
        mode = { "n" },
        lhs = [[I]],
        rhs = [[<Plug>(deol_start_insert_first)]],
        opts = deol_opt,
    },
    {
        mode = { "n" },
        lhs = [[a]],
        rhs = [[<Plug>(deol_start_append)]],
        opts = deol_opt,
    },
    {
        mode = { "n" },
        lhs = [[A]],
        rhs = [[<Plug>(deol_start_append_last)]],
        opts = deol_opt,
    },
    {
        mode = { "n" },
        lhs = [[p]],
        rhs = [[<Plug>(deol_paste_prompt)]],
        opts = deol_opt,
    },
    {
        mode = { "n" },
        lhs = [[<CR>]],
        rhs = [[<Plug>(deol_execute_line)]],
        opts = deol_opt,
    },
})
-- }}}
