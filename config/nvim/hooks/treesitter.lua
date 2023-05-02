-- lua_source {{{
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = vim.treesitter.foldexpr()
vim.opt.foldenable = false
require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  highlight = {
    enable = true,
    disable = {
      'vimdoc',
    },
  },
  indent = {
    enable = true,
    disable = {
      'vimdoc',
    },
  },
})
-- }}}
