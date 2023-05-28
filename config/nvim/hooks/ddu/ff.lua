-- lua_ddu-ff {{{
local do_action = vim.fn['ddu#ui#do_action']
local line = vim.fn.line

local ff_opt = { silent = true, buffer = true, noremap = true }
local ff_opt_expr = { silent = true, buffer = true, expr = true, noremap = true }
require('user.utils').keymaps_set({
  {
    mode = "n",
    lhs = [[<CR>]],
    rhs = function()
      do_action('itemAction')
    end,
    opts = ff_opt,
  },
  {
    mode = "n",
    lhs = [[o]],
    rhs = function()
      do_action('itemAction', {
        name = [[open]],
        params = {
          command = [[drop]]
        }
      })
    end,
    opts = ff_opt,
  },
  {
    mode = "n",
    lhs = [[s]],
    rhs = function()
      do_action('itemAction', {
        name = [[open]],
        params = { command = [[split]] }
      })
    end,
    opts = ff_opt,
  },
  {
    mode = "n",
    lhs = [[v]],
    rhs = function()
      do_action('itemAction', {
        name = [[open]],
        params = { command = [[vsplit]] }
      })
    end,
    opts = ff_opt,
  },
  {
    mode = "n",
    lhs = [[t]],
    rhs = function()
      do_action('itemAction', {
        name = [[open]],
        params = { command = [[tabedit]] }
      })
    end,
    opts = ff_opt,
  },
  {
    mode = "n",
    lhs = [[  ]],
    rhs = function()
      do_action('toggleSelectItem')
    end,
    opts = ff_opt,
  },
  {
    mode = "n",
    lhs = [[*]],
    rhs = function()
      do_action('toggleAllItems')
    end,
    opts = ff_opt,
  },
  {
    mode = "n",
    lhs = [[a]],
    rhs = function()
      do_action('chooseAction')
    end,
    opts = ff_opt,
  },
  {
    mode = "n",
    lhs = [[i]],
    rhs = function()
      do_action('openFilterWindow')
    end,
    opts = ff_opt,
  },
  {
    mode = "n",
    lhs = [[<C-l>]],
    rhs = function()
      do_action('refreshItems')
    end,
    opts = ff_opt,
  },
  {
    mode = "n",
    lhs = [[p]],
    rhs = function()
      do_action('preview')
    end,
    opts = ff_opt,
  },
  {
    mode = "n",
    lhs = [[q]],
    rhs = function()
      do_action('quit')
    end,
    opts = ff_opt,
  },
  {
    mode = "n",
    lhs = [[<ESC>]],
    rhs = function()
      do_action('quit')
    end,
    opts = ff_opt
  },
  {
    mode = "n",
    lhs = [[j]],
    rhs = function()
      if line('.') == line('$') then
        return [[gg]]
      else
        return [[j]]
      end
    end,
    opts = ff_opt_expr,
  },
  {
    mode = "n",
    lhs = [[k]],
    rhs = function()
      if line('.') == 1 then
        return [[G]]
      else
        return [[k]]
      end
    end,
    opts = ff_opt_expr,
  },
  {
    mode = "n",
    lhs = [[<C-q>]],
    rhs = function()
      do_action('toggleAllItems')
      do_action('itemAction', { name = [[quickfix]] })
    end,
    opts = ff_opt,
  },
  {
    mode = "n",
    lhs = [[y]],
    rhs = function()
      do_action('yank')
      print('Yank path the "' .. vim.fn.getreg('+') .. '"')
    end,
    opts = ff_opt,
  },
})
-- }}}

-- lua_ddu-ff-filter {{{
local do_action = vim.fn['ddu#ui#do_action']
local filter_opt = { buffer = true, noremap = true }
require('user.utils').keymaps_set({
  -- filter insert mode
  {
    mode = "i",
    lhs = [[<CR>]],
    rhs = function()
      vim.cmd('stopinsert')
      do_action('closeFilterWindow')
    end,
    opts = filter_opt,
  },
  {
    mode = "i",
    lhs = [[jj]],
    rhs = function()
      vim.cmd('stopinsert')
      do_action('closeFilterWindow')
    end,
    opts = filter_opt,
  },
  {
    mode = "i",
    lhs = [[<ECS>]],
    rhs = function()
      vim.cmd('stopinsert')
      do_action('closeFilterWindow')
    end,
    opts = filter_opt,
  },

  -- filter normal mode
  {
    mode = "n",
    lhs = [[q]],
    rhs = function()
      do_action('closeFilterWindow')
    end,
    opts = filter_opt,
  },
  {
    mode = "n",
    lhs = [[<CR>]],
    rhs = function()
      do_action('closeFilterWindow')
    end,
    opts = filter_opt,
  },
  {
    mode = "n",
    lhs = [[j]],
    rhs = function()
      do_action('closeFilterWindow')
    end,
    opts = filter_opt,
  },
  {
    mode = "n",
    lhs = [[<ESC>]],
    rhs = function()
      do_action('closeFilterWindow')
    end,
    opts = filter_opt,
  },
})
-- }}}
