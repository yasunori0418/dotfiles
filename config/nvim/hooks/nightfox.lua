-- lua_source {{{
require("nightfox").setup({
  options = {
    -- Compiled file's destination location
    compile_path = vim.fn.stdpath("cache") .. "/nightfox",
    compile_file_suffix = "_compiled", -- Compiled file suffix
    transparent = false, -- Disable setting background
    terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*)
    dim_inactive = false, -- Non focused panes set to alternative background
    module_default = true,
    styles = { -- Style to be applied to different syntax groups
      comments = "italic",
      conditionals = "NONE",
      constants = "NONE",
      functions = "bold",
      keywords = "NONE",
      numbers = "NONE",
      operators = "NONE",
      strings = "NONE",
      types = "NONE",
      variables = "NONE",
    },
    inverse = { -- Inverse highlight for different types
      match_paren = false,
      visual = true,
      search = false,
    },
    modules = { -- List of various plugins and additional options
      fidget = true,
      lsp_saga = true,
      notify = true,
      treesitter = true,
    },
  },
})
vim.cmd([[colorscheme nordfox]])
-- }}}

-- lua_post_source {{{
if vim.fn.isdirectory(vim.fn.stdpath("cache") .. "/nightfox") then
  if vim.fn.empty(vim.fn.systemlist("ls " .. vim.fn.stdpath("cache") .. "/nightfox")) > 0 then
    require("nightfox").compile()
  end
else
  require("nightfox").compile()
end
-- }}}
