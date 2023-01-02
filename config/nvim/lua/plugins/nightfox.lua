local M = {}

local nightfox = require('nightfox')
local compile_path = vim.fn.stdpath('cache') .. '/nightfox'

function M.setup()
  nightfox.setup({
    options = {
      -- Compiled file's destination location
      compile_path = compile_path,
      compile_file_suffix = '_compiled', -- Compiled file suffix
      transparent = false, -- Disable setting background
      terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*)
      dim_inactive = false, -- Non focused panes set to alternative background
      module_default = true,
      styles = { -- Style to be applied to different syntax groups
        comments = 'italic',
        conditionals = 'NONE',
        constants = 'NONE',
        functions = 'bold',
        keywords = 'NONE',
        numbers = 'NONE',
        operators = 'NONE',
        strings = 'NONE',
        types = 'NONE',
        variables = 'NONE',
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
end

function M.compile()
  if vim.fn.isdirectory(compile_path) then
    if vim.fn.empty(vim.fn.systemlist('ls ' .. compile_path)) > 0 then
      nightfox.compile()
    end
  else
    nightfox.compile()
  end
end

return M
