-- lua_source {{{

local highlight = {
  "NordRed",
  "NordYellow",
  "NordBlue",
  "NordOrange",
  "NordGreen",
  "NordCyan",
}
local hooks = require("ibl.hooks")
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "NordRed", { fg = "#BF616A" })
  vim.api.nvim_set_hl(0, "NordYellow", { fg = "#EBCB8B" })
  vim.api.nvim_set_hl(0, "NordBlue", { fg = "#5E81AC" })
  vim.api.nvim_set_hl(0, "NordOrange", { fg = "#D08770" })
  vim.api.nvim_set_hl(0, "NordGreen", { fg = "#A3BE8C" })
  vim.api.nvim_set_hl(0, "NordCyan", { fg = "#B48EAD" })
end)

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
