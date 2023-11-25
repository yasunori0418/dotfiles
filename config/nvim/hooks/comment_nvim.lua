-- lua_add {{{
local opt = { silent = true, noremap = false }
local opt_expr = { silent = true, noremap = false, expr = true }

-- 基本マッピングの発火でプラグインを読み込むために、ここで設定する。
require("user.utils").keymaps_set({
    { mode = { "o", "n" }, lhs = [[gc]], rhs = [[<Plug>(comment_toggle_linewise)]], opts = opt },
    { mode = { "o", "n" }, lhs = [[gb]], rhs = [[<Plug>(comment_toggle_blockwise)]], opts = opt },
    { mode = { "x" }, lhs = [[gc]], rhs = [[<Plug>(comment_toggle_linewise_visual)]], opts = opt },
    { mode = { "x" }, lhs = [[gb]], rhs = [[<Plug>(comment_toggle_blockwise)]], opts = opt },
    {
        mode = { "n" },
        lhs = [[gcc]],
        rhs = function()
            if vim.v.count == 0 then
                return [[<Plug>(comment_toggle_linewise_current)]]
            else
                return [[<Plug>(comment_toggle_linewise_count)]]
            end
        end,
        opts = opt_expr,
    },
    {
        mode = { "n" },
        lhs = [[gbc]],
        rhs = function()
            if vim.v.count == 0 then
                return [[<Plug>(comment_toggle_blockwise_current)]]
            else
                return [[<Plug>(comment_toggle_blockwise_count)]]
            end
        end,
        opts = opt_expr,
    },
})
-- }}}

-- lua_source {{{

require("Comment").setup({
    padding = true,
    sticky = true,
    ignore = "^$",
    toggler = { line = "gcc", block = "gbc" },
    opleader = { line = "gc", block = "gb" },
    extra = { above = "gcO", below = "gco", eol = "gcA" },
    mappings = {
        basic = false,
        -- クッ…デフォルト設定を許容するしかないのか…。
        extra = true,
    },
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    post_hook = function()end,
})

-- }}}
