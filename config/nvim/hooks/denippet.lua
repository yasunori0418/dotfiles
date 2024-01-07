-- lua_source {{{
local utils = require("user.utils")

local snippets = {}
local friendly = require("dpp").get("friendly-snippets").rtp
table.insert(snippets, vim.fn.globpath(friendly, "**/*.json", true, true))
table.insert(snippets, vim.fn.globpath(vim.g.snippet_dir, "**/*.json", true, true))
for _, path in pairs(vim.tbl_flatten(snippets)) do
    local name = vim.fn.fnamemodify(path, ":t:r")
    -- local parent_dirs = vim.fn.split(vim.fn.fnamemodify(path, ":h"), "/")
    -- local parent_dirname = utils.last(parent_dirs)
    -- vim.print(parent_dirname .. ": " .. name)
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
            if vim.fn["denippet#jumpable"](1) > 0 then
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
            if vim.fn["denippet#jumpable"](-1) > 0 then
                return [[<Plug>(denippet-jump-prev)]]
            else
                return [[<C-G>U<Left>]]
            end
        end,
        opts = opt_expr,
    },
})
-- }}}
