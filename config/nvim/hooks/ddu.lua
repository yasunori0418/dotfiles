-- lua_add {{{
local opt = { noremap = false }
require("user.utils").keymaps_set({
  -- ddu start prefixes
  { mode = "n", lhs = [[ d]], rhs = [[<Plug>(ddu-ff)]],    opts = opt },
  { mode = "n", lhs = [[ f]], rhs = [[<Plug>(ddu-filer)]], opts = opt },

  -- ddu-ui-ff starter
  { -- current-ff
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
  { -- dorfiles-ff
    mode = "n",
    lhs = [[<Plug>(ddu-ff)d]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "dotfiles-ff" })
    end,
    opts = opt,
  },
  { -- help-ff
    mode = "n",
    lhs = [[<Plug>(ddu-ff)h]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "help-ff" })
    end,
    opts = opt,
  },
  { -- buffer-ff
    mode = "n",
    lhs = [[<Plug>(ddu-ff)b]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "buffer-ff" })
    end,
    opts = opt,
  },
  { -- plugin-list-ff
    mode = "n",
    lhs = [[<Plug>(ddu-ff)P]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "plugin-list-ff" })
    end,
    opts = opt,
  },
  { -- project-list-ff
    mode = "n",
    lhs = [[<Plug>(ddu-ff)p]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "project-list-ff" })
    end,
    opts = opt,
  },
  { -- home-ff
    mode = "n",
    lhs = [[<Plug>(ddu-ff)~]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "home-ff" })
    end,
    opts = opt,
  },
  { -- register-ff
    mode = "n",
    lhs = [[<Plug>(ddu-ff)r]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "register-ff" })
    end,
    opts = opt,
  },
  { -- ripgrep-ff live grep
    mode = "n",
    lhs = [[<Plug>(ddu-ff)s]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "ripgrep-ff" })
    end,
    opts = opt,
  },
  { -- mrr-ff most recent repositories
    mode = "n",
    lhs = [[<Plug>(ddu-ff)m]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "mrr-ff" })
    end,
    opts = opt,
  },
  { -- mru-ff most recent used files
    mode = "n",
    lhs = [[<Plug>(ddu-ff)n]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "mru-ff" })
    end,
    opts = opt,
  },
  { -- search_line-ff
    mode = "n",
    lhs = [[<Plug>(ddu-ff)/]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "search_line-ff" })
    end,
    opts = opt,
  },
  { -- hightlight-ff
    mode = "n",
    lhs = [[<Plug>(ddu-ff)C]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "highlight-ff" })
    end,
    opts = opt,
  },

  -- ddu-ui-filer starter
  { -- project_root-filer
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
  { -- current-filer open filer at current buffer directory
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
  { -- dotfiles-filer
    mode = "n",
    lhs = [[<Plug>(ddu-filer)d]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "dotfiles-filer" })
    end,
    opts = opt,
  },
  { -- home-filer
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
    previewFloatingBorder = [[single]],
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
    converters = { "converter_devicon" },
  },
  -- file = {
    -- columns = { "icon_filename" },
  -- },
  dein = {
    defaultAction = [[cd]],
  },
  help = {
    defaultAction = [[open]],
  },
  dein_update = {
    matchers = {'matcher_dein_update'},
  },
  path_history = {
    defaultAction = [[uiCd]],
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
  dein_update = {
    defaultAction = [[viewDiff]],
  }
}

local action_options = {
  narrow = { quit = false },
  echo = { quit = false },
  echoDiff = { quit = false },
}

-- Global option and param
vim.fn["ddu#custom#patch_global"]({
  uiOptions = ui_options,
  uiParams = ui_params,
  sourceOptions = source_options,
  sourceParams = source_params,
  kindOptions = kind_options,
  actionOptions = action_options,
})

vim.fn['ddu#custom#action']('kind', 'file', 'uiCd',
  function(args)
    local path = args.items[1].action.path
    local directory = path
    if vim.fn.isdirectory(directory) == 0 then
      directory = vim.fn.fnamemodify(directory, ':h')
    end
    vim.print(directory)
    vim.fn['ddu#ui#do_action']([[itemAction]], {
      name = [[narrow]],
      params = { path = directory }
    })
  end
)

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

vim.api.nvim_create_user_command(
  'DeinUpdate',
  function(opts)
    local use_graph_ql = false
    if opts.bang then
      use_graph_ql = vim.fn['vimrc#is_github_pat']()
    end
    vim.fn['ddu#start']({
      name ='dein_update-ff',
      ui = 'ff',
      sources = {
        {
          name = 'dein_update',
          params = { useGraphQL = use_graph_ql },
        },
      },
    })
  end,
  { bang = true }
)

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

vim.fn['ddu#custom#patch_local']('path_history-filer', {
  ui = 'ff',
  sources = {
    { name = 'path_history' }
  },
})

-- }}}
