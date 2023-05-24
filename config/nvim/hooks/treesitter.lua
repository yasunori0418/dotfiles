-- lua_source {{{
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
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
    enable = false
  },
  yati = {
    enable = true,
    default_lazy = true,
    default_fallback = "auto",
  },
})
-- }}}
