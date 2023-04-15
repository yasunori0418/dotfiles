-- lua_source {{{
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
