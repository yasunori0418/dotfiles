-- lua_add {{{
local opt = { noremap = false }
require("user.utils").keymaps_set({
  -- ddu start prefixes
  { mode = "n", lhs = [[ d]], rhs = [[<Plug>(ddu-ff)]],    opts = opt },
  { mode = "n", lhs = [[ f]], rhs = [[<Plug>(ddu-filer)]], opts = opt },

  -- ddu-ui-ff starter
  {
    mode = "n",
    lhs = [[<Plug>(ddu-ff)a]],
    rhs = function()
      vim.fn["ddu#start"]({
        name = "current-ff",
        sourceOptions = {
          file_rec = {
            path = vim.fn["vimrc#search_repo_root"](),
          },
        },
      })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[<Plug>(ddu-ff)d]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "dotfiles-ff" })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[<Plug>(ddu-ff)h]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "help-ff" })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[<Plug>(ddu-ff)b]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "buffer-ff" })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[<Plug>(ddu-ff)P]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "plugin-list-ff" })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[<Plug>(ddu-ff)p]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "project-list-ff" })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[<Plug>(ddu-ff)~]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "home-ff" })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[<Plug>(ddu-ff)r]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "register-ff" })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[<Plug>(ddu-ff)s]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "ripgrep-ff" })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[<Plug>(ddu-ff)m]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "mrr-ff" })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[<Plug>(ddu-ff)n]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "mru-ff" })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[<Plug>(ddu-ff)/]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "search_line-ff" })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[<Plug>(ddu-ff)C]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "highlight-ff" })
    end,
    opts = opt,
  },

  -- ddu-ui-filer starter
  {
    mode = "n",
    lhs = [[<Plug>(ddu-filer)a]],
    rhs = function()
      vim.fn["ddu#start"]({
        name = "project_root-filer",
        sourceOptions = {
          file = {
            path = vim.fn["vimrc#search_repo_root"](),
          },
        },
      })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[<Plug>(ddu-filer)f]],
    rhs = function()
      vim.fn["ddu#start"]({
        name = "current-filer",
        sourceOptions = {
          file = {
            path = vim.fn.expand("%:p:h"),
          },
        },
      })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[<Plug>(ddu-filer)d]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "dotfiles-filer" })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[<Plug>(ddu-filer)~]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "home-filer" })
    end,
    opts = opt,
  },
})
-- }}}

-- lua_source {{{
local ui_options = {
  filer = {
    toggle = true,
  },
}

local ui_params = {
  ff = {
    split = [[floating]],
    floatingBorder = [[single]],
    prompt = [[]],
    filterSplitDirection = [[floating]],
    filterFloatingPosition = [[top]],
    displaySourceName = [[long]],
    previewFloating = true,
    previewFloatingBorder = [[double]],
    previewSplit = [[horizontal]],
  },
  filer = {
    split = [[vertical]],
    splitDirection = [[topleft]],
    winWidth = vim.opt.columns:get() / 6,
    previewFloating = true,
    previewFloatingBorder = [[double]],
    previewCol = vim.opt.columns:get() / 4,
    previewRow = vim.opt.lines:get() / 2,
    previewWidth = vim.opt.columns:get() / 2,
    previewHeight = 20,
  },
}

local source_options = {
  _ = {
    ignoreCase = true,
    matchers = { "matcher_substring" },
  },
  file = {
    columns = { "icon_filename" },
  },
  dein = {
    defaultAction = [[cd]],
  },
  help = {
    defaultAction = [[open]],
  },
}

local source_params = {
  dein_update = {
    useGraphQL = true,
  },
  marks = {
    jumps = true,
  },
  rg = {
    args = {
      [[--json]],
      [[--ignore-case]],
      [[--column]],
      [[--no-heading]],
      [[--color]],
      [[never]],
    },
    highlights = {
      word = [[Title]],
    },
  },
}

local kind_options = {
  file = {
    defaultAction = [[open]],
  },
  action = {
    defaultAction = [[do]],
  },
  word = {
    defaultAction = [[append]],
  },
  deol = {
    defaultAction = [[switch]],
  },
  readme_viewer = {
    defaultAction = [[open]],
  },
}

local action_options = {
  narrow = { quit = false },
  echo = { quit = false },
  echoDiff = { quit = false },
}

local column_params = {
  icon_filename = {
    span = 2,
    iconWidth = 2,
    defaultIcon = {
      icon = [[]],
    },
  },
}

-- Global option and param
vim.fn["ddu#custom#patch_global"]({
  uiOptions = ui_options,
  uiParams = ui_params,
  sourceOptions = source_options,
  sourceParams = source_params,
  kindOptions = kind_options,
  actionOptions = action_options,
  columnParams = column_params,
})

-- UI:ff presets
vim.fn['ddu#custom#patch_local']('current-ff', {
  ui = 'ff',
  uiParams = {
    ff = {
      startFilter = true,
    },
  },
  sources = {
    { name = 'file_rec' },
  },
})

vim.fn['ddu#custom#patch_local']('dotfiles-ff', {
  ui = 'ff',
  uiParams = {
    ff = {
      startFilter = true,
    },
  },
  sourceOptions = {
    file_rec = {
      path = vim.fn.expand('~/dotfiles')
    },
  },
  sources = {
    { name = 'file_rec' }
  },
})

vim.fn['ddu#custom#patch_local']('project-list-ff', {
  ui = 'ff',
  uiParams = {
    ff = {
      startFilter = true,
    },
  },
  sourceOptions = {
    file = {
      path = vim.env.WORKING_DIR,
    },
  },
  sources = {
    { name = 'file' },
  },
})

vim.fn['ddu#custom#patch_local']('help-ff', {
  ui = 'ff',
  uiParams = {
    ff = {
      startFilter = true,
      },
    },
  sources = {
    { name = 'help' },
    { name = 'readme_viewer' },
  },
})

local lines = vim.opt.lines:get()
local columns = vim.opt.columns:get()
local win_width = math.floor(columns / 3)
local win_height = lines - 5
vim.fn['ddu#custom#patch_local']('ripgrep-ff', {
  ui = 'ff',
  uiParams = {
    ff = {
      autoAction = {
        delay = 0,
        name = [[preview]],
      },
      filterFloatingPosition = [[bottom]],
      previewCol = columns - win_width,
      -- previewRow = 0,
      previewWidth = columns - win_width - 5,
      -- previewSplitがverticalならwinWidthにひっぱられるので不要
      -- previewHeight = win_height + 1,
      previewSplit = [[vertical]],
      previewWindowOptions = {
        { "&signcolumn", "no" },
        { "&foldcolumn", 0 },
        { "&foldenable", 0 },
        { "&number", 0 },
        { "&relativenumber", 0 },
        { "&wrap", 0 },
      },
      winCol = 1,
      winRow = math.floor(lines / 2 - 20),
      winHeight = win_height,
      winWidth = win_width,
      ignoreEmpty = false,
      autoResize = false,
      startFilter = true,
    },
  },
  sources = {
    {
      name = 'rg',
      options = {
        matchers = {},
        volatile = true,
      },
    }
  },
})

vim.fn['ddu#custom#patch_local']('search_line-ff', {
  ui = 'ff',
  uiParams = {
    ff = { startFilter = true },
  },
  sources = {
    { name = 'line' }
  }
})

vim.fn['ddu#custom#patch_local']('buffer-ff', {
  ui = 'ff',
  sources = {
    { name = 'buffer' },
  },
})

vim.fn['ddu#custom#patch_local']('plugin-list-ff', {
  ui = 'ff',
  uiParams = {
    ff = {
      startFilter = true,
    }
  },
  sources = {
    { name = 'dein' },
  },
})

vim.fn['ddu#custom#patch_local']('home-ff', {
  ui = 'ff',
  uiParams = {
    ff = {
      startFilter = true,
    },
  },
  sourceOptions = {
    file = {path = vim.env.HOME},
  },
  sources = {
    { name = 'file' },
  },
})

vim.fn['ddu#custom#patch_local']('register-ff', {
  ui = 'ff',
  sources = {
    { name = 'register' }
  },
})

vim.fn['ddu#custom#patch_local']('mrr-ff', {
  ui = 'ff',
  uiParams = {
    ff = {
      startFilter = true,
      },
    },
  sources = {
    {
      name = 'mr',
      params = {
        kind = 'mrr',
        current = false,
      },
    },
  },
})

vim.fn['ddu#custom#patch_local']('mru-ff', {
  ui = 'ff',
  uiParams = {
    ff = {
      startFilter = true,
    },
  },
  sources = {
    {
      name = 'mr',
      params = {
        kind = 'mru',
        current = true,
      },
    },
  },
})

vim.fn['ddu#custom#patch_local']('highlight-ff', {
  ui = 'ff',
  uiParams = {
    ff = {
      startFilter = true,
    },
  },
  sources = {
    { name = 'highlight' }
  },
})


-- -- UI:filer presets
vim.fn['ddu#custom#patch_local']('current-filer', {
  ui = 'filer',
  sources = {
    { name = 'file' }
  },
})

vim.fn['ddu#custom#patch_local']('project_root-filer', {
  ui = 'filer',
  sources = {
    { name = 'file' }
  },
})

vim.fn['ddu#custom#patch_local']('dotfiles-filer', {
  ui = 'filer',
  sources = {
    { name = 'file' }
  },
  sourceOptions = {
    file = {
      path = vim.env.HOME .. '/dotfiles'
    },
  },
})

vim.fn['ddu#custom#patch_local']('home-filer', {
  ui = 'filer',
  sources = {
    { name = 'file' }
  },
  sourceOptions = {
    file = {
      path = vim.env.HOME,
    },
  },
})

-- }}}
