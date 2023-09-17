-- lua_add {{{
local utils = require('user.utils')

---@param path? string default: vim.fn.getcwd()
---@param split? string default: 'floating'
---@return table
local deol_create_option = function(path, split)
  path = path or vim.fn.getcwd()
  split = split or 'floating'

  local winheight = ''
  if vim.regex([[floating\|horizontal]]):match_str(split) then
    winheight = '-winheight=' .. vim.fn.float2nr(vim.opt.lines:get() / 1.5)
  end

  local winwidth = ''
  if vim.regex([[floating\|vertical]]):match_str(split) then
    winwidth = '-winwidth=' .. vim.fn.float2nr(vim.opt.columns:get() / 1.5)
  end

  local deol_opt = {
    'Deol',
    '-no-auto-cd',
    '-no-start-insert',
    '-cwd=' .. path,
    '-split=' .. split,
    winwidth,
    winheight,
    '-toggle',
  }
  return vim.fn.map(
    deol_opt,
    function(_, value)
      return '"' .. value .. '"'
    end
  )
end

local opt = { silent = true, noremap = true }
utils.keymaps_set{
  { -- leave term insert mode.
    mode = "t",
    lhs = [[<Esc><Esc>]],
    rhs = [[<C-\><C-n>]],
    opts = opt
  },
  { -- term prefix
    mode = "n",
    lhs = [[ s]],
    rhs = [[<Plug>(term)]],
    opts = {}
  },
  { -- project root term
    mode = "n",
    lhs = [[<Plug>(term)a]],
    rhs = function()
      vim.cmd{
        cmd = 'execute',
        args = deol_create_option()
      }
    end,
    opts = opt,
  },
  { -- current buffer term
    mode = "n",
    lhs = [[<Plug>(term)c]],
    rhs = function()
      vim.cmd{
      cmd = 'execute',
      args = deol_create_option(vim.fn.fnamemodify(vim.fn.expand('%'), ':h'))
      }
    end,
    opts = opt,
  },
  { -- $HOME term
    mode = "n",
    lhs = [[<Plug>(term)~]],
    rhs = function()
      vim.cmd{
      cmd = 'execute',
      args = deol_create_option('~')
      }
    end,
    opts = opt,
  },
  { -- tab term
    mode = "n",
    lhs = [[<Plug>(term)t]],
    rhs = function ()
      vim.cmd.tabnew()
      vim.cmd{
        cmd = 'execute',
        args = deol_create_option(vim.fn.getcwd(), '')
      }
    end,
    opts = opt,
  },
  { -- これはリファレンス実装。意図は分かっていない…
    mode = "t",
    lhs = [[<C-t>]],
    rhs = [[<Tab>]],
    opts = opt,
  },
  { -- completion select
    mode = "t",
    lhs = [[<Tab>]],
    rhs = function()
      if vim.fn["pum#visible"]() then
        vim.fn["pum#map#select_relative"](1)
      else
        vim.api.nvim_feedkeys([[<Tab>]], "n", true)
      end
    end,
    opts = opt,
  },
  { -- completion select with reverse curosor move
    mode = "t",
    lhs = [[<S-Tab>]],
    rhs = function()
      if vim.fn["pum#visible"]() then
        vim.fn["pum#map#select_relative"](-1)
      else
        vim.api.nvim_feedkeys([[<S-Tab>]], "n", true)
      end
    end,
    opts = opt,
  },
  { -- completion confirm
    mode = "t",
    lhs = [[<C-y>]],
    rhs = function()
      vim.fn["pum#map#confirm"]()
    end,
    opts = opt,
  },
}
-- }}}

-- lua_source {{{
vim.g['deol#external_history_path'] = vim.fn.expand('~/.zhistory')
vim.g['deol#nvim_server'] = '~/.cache/nvim/server.pipe'
vim.g['deol#custom_map'] = {edit = ''}
vim.g['deol#floating_border'] = 'single'
vim.g['deol#enable_dir_changed'] = false
vim.g['deol#prompt_pattern'] = '❯ '
-- }}}
