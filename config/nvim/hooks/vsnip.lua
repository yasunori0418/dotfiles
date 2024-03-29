-- lua_source {{{
local joinpath = vim.fs.joinpath
local utils = require("user.utils")

vim.g.vsnip_extra_mapping = false
vim.g.vsnip_snippet_dir = vim.g.snippet_dir

local friendly_snippets_dir = joinpath(vim.g.vsnip_snippet_dir, "friendly-snippets")
vim.g.vsnip_snippet_dirs = {
    friendly_snippets_dir,
    joinpath(friendly_snippets_dir, "javascript"),
    joinpath(friendly_snippets_dir, "python"),
    joinpath(friendly_snippets_dir, "php"),
    joinpath(friendly_snippets_dir, "lua"),
    joinpath(friendly_snippets_dir, "shell"),
    joinpath(friendly_snippets_dir, "ruby"),
}
vim.g.vsnip_filetypes = vim.empty_dict()
vim.g.vsnip_integ_create_autocmd = false

utils.autocmd_set("InsertEnter", "$BASE_DIR/toml/*.toml", function()
    vim.g.vsnip_filetypes.toml = { vim.fn["context_filetype#get_filetype"]() }
end)

local opt_expr = { noremap = false, expr = true }
utils.keymaps_set({
    {
        mode = { "i", "s" },
        lhs = [[<C-f>]],
        rhs = function()
            if vim.fn["vsnip#jumpable"](1) > 0 then
                return [[<Plug>(vsnip-jump-next)]]
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
            if vim.fn["vsnip#jumpable"](-1) > 0 then
                return [[<Plug>(vsnip-jump-prev)]]
            else
                return [[<C-G>U<Left>]]
            end
        end,
        opts = opt_expr,
    },
})
-- }}}
