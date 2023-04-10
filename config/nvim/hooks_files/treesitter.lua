-- lua_source {{{
require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  highlight = {
    enable = true,
    disable = {
      'help',
    },
  },
  indent = {
    enable = true,
    disable = {
      'help',
    },
  },
})
-- }}}
