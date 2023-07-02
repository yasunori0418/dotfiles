-- lua_source {{{
local joinpath = vim.fs.joinpath
local utils = require("user.utils")

vim.g.vsnip_extra_mapping = false
vim.g.vsnip_snippet_dir = joinpath(vim.g.snippet_dir, "vsnip")
vim.g.vsnip_snippet_dirs = { joinpath(vim.g.vsnip_snippet_dir, "vsnip", "friendly-snippets", "snippets") }
vim.g.vsnip_filetypes = vim.empty_dict()
vim.g.vsnip_integ_create_autocmd = false

utils.autocmd_set("InsertEnter", "~/dotfiles/config/nvim/toml/*.toml", function()
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
