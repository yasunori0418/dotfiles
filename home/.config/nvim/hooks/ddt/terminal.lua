-- lua_ddt-terminal {{{
local opt = { silent = false, buffer = true, noremap = true }
require("user.utils").keymaps_set({
    {
        mode = { "n" },
        lhs = [[<C-n>]],
        rhs = function()
            vim.fn["ddt#ui#do_action"]("nextPrompt")
        end,
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<C-p>]],
        rhs = function()
            vim.fn["ddt#ui#do_action"]("previousPrompt")
        end,
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<C-y>]],
        rhs = function()
            vim.fn["ddt#ui#do_action"]("pastePrompt")
        end,
        opts = opt,
    },
    {
        mode = { "n", "i" },
        lhs = [[<CR>]],
        rhs = function()
            vim.fn["ddt#ui#do_action"]("executeLine")
        end,
        opts = opt,
    },
    {
        mode = { "i" },
        lhs = [[<C-c>]],
        rhs = function()
            vim.fn["ddt#ui#do_action"]("terminate")
        end,
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<C-l>]],
        rhs = function()
            vim.fn["ddt#ui#do_action"]("redraw")
        end,
        opts = opt,
    },
})

vim.api.nvim_create_autocmd("DirChanged", {
    group = require("user.utils").vimrc_augroup,
    callback = function(event)
        vim.print(event)
        vim.fn["ddt#ui#do_action"]("cd", {
            directory = vim.fn.get(event, "cwd", vim.fn.getcwd()),
        })
    end,
    buffer = vim.fn.bufnr("%"),
})

-- }}}
