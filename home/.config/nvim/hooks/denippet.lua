-- lua_source {{{
local utils = require("user.utils")

local snippets = {}
table.insert(snippets, vim.fn.globpath(require("user.rc").snippet_dir, "**/*.*", true, true))
for _, path in pairs(vim.iter(snippets):flatten():totable()) do
    local name = vim.fn.fnamemodify(path, ":t:r")
    if name == "global" then
        vim.fn["denippet#load"](path, "")
    else
        vim.fn["denippet#load"](path)
    end
end

local opt_expr = { noremap = false, expr = true }
utils.keymaps_set({
    {
        mode = { "i", "s" },
        lhs = [[<C-f>]],
        rhs = function()
            if vim.fn["denippet#jumpable"](1) then
                return [[<Plug>(denippet-jump-next)]]
            else
                return [[<C-G>U<Right>]]
            end
        end,
        opts = opt_expr,
    },
    {
        mode = { "i", "s" },
        lhs = [[<C-b>]],
        rhs = function()
            if vim.fn["denippet#jumpable"](-1) then
                return [[<Plug>(denippet-jump-prev)]]
            else
                return [[<C-G>U<Left>]]
            end
        end,
        opts = opt_expr,
    },
})
-- }}}
