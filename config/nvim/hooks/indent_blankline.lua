-- lua_source {{{
require("indent_blankline").setup({
  char_list = { "│", "|", "¦", "┆", "┊" },
  char_list_blankline = { "│", "|", "¦", "┆", "┊" },
  show_current_context = true,
  show_current_context_start = true,
  show_current_context_start_on_current_line = true,
  show_end_of_line = true,
  show_first_indent_level = true,
  show_trailing_blankline_indent = true,
  space_char_blankline = " ",
  strict_tabs = true,
  use_treesitter = true,
  filetype_exclude = {
    "lspinfo",
    "packer",
    "checkhealth",
    "help",
    "man",
    "",
  },
  buftype_exclude = {
    "terminal",
    "nofile",
    "quickfix",
    "prompt",
  },
  bufname_exclude = {},
})
-- }}}
