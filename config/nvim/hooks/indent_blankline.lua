-- lua_source {{{
require("ibl").setup({
  enable = true,
  debounce = 100,
  viewport_buffer = { min = 30, max = 500 },
  indent = {
    char = "┊",
    highlight = highlight,
    smart_indent_cap = true,
  },
  whitespace = {
    remove_blankline_trail = true,
  },
  scope = {
    enable = false,
  },
  exclude = {
    filetypes = {
      "",
      "checkhealth",
      "gitcommit",
      "help",
      "lspinfo",
      "man",
    },
    buftypes = {
      "nofile",
      "prompt",
      "quickfix",
      "terminal",
    },
  },
})
-- }}}
