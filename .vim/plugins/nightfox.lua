local nightfox = require("nightfox")

nightfox.setup({
  options = {
    -- Compiled file's destination location
    compile_path = vim.fn.stdpath("cache") .. "/nightfox",
    compile_file_suffix = "_compiled", -- Compiled file suffix
    transparent = false,    -- Disable setting background
    terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*)
    dim_inactive = true,   -- Non focused panes set to alternative background
    styles = {              -- Style to be applied to different syntax groups
      comments = "italic",
      functions = "bold",
      keywords = "NONE",
      numbers = "NONE",
      strings = "NONE",
      types = "NONE",
      variables = "NONE",
      },
    inverse = {             -- Inverse highlight for different types
      match_paren = false,
      visual = true,
      search = false,
      },
    modules = {             -- List of various plugins and additional options
      },
    },
  })

-- Load the configuration set above and apply the colorscheme
vim.cmd("colorscheme duskfox")
