-- lua_ddt-shell {{{
local opt = {
    silent = false,
    buffer = true,
    noremap = true,
    desc = 'set from hooks/ddt/shell.lua'
} --[[@type vim.keymap.set.Opts]]

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
})
-- }}}
