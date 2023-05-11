-- lua_ddu-ff {{{
-- Open file keybinds.
local ff_opt = { silent = true, buffer = true, noremap = true }
local ff_opt_expr = { silent = true, buffer = true, expr = true, noremap = true }
require('user.utils').keymaps_set({
  {
    mode = "n",
    lhs = [[<CR>]],
    rhs = function()
      vim.fn['ddu#ui#ff#do_action']('itemAction')
    end,
    opts = ff_opt,
  },
  {
    mode = "n",
    lhs = [[o]],
    rhs = function()
      vim.fn['du#ui#ff#do_action']('itemAction', {
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
      vim.fn['ddu#ui#do_action']('itemAction', {
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
      vim.fn['ddu#ui#do_action']('itemAction', {
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
      vim.fn['ddu#ui#do_action']('itemAction', {
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
      vim.fn['ddu#ui#do_action']('toggleSelectItem')
    end,
    opts = ff_opt,
  },
  {
    mode = "n",
    lhs = [[*]],
    rhs = function()
      vim.fn['ddu#ui#do_action']('toggleAllItems')
    end,
    opts = ff_opt,
  },
  {
    mode = "n",
    lhs = [[a]],
    rhs = function()
      vim.fn['ddu#ui#do_action']('chooseAction')
    end,
    opts = ff_opt,
  },
  {
    mode = "n",
    lhs = [[i]],
    rhs = function()
      vim.fn['ddu#ui#do_action']('openFilterWindow')
    end,
    opts = ff_opt,
  },
  {
    mode = "n",
    lhs = [[<C-l>]],
    rhs = function()
      vim.fn['ddu#ui#do_action']('refreshItems')
    end,
    opts = ff_opt,
  },
  {
    mode = "n",
    lhs = [[p]],
    rhs = function()
      vim.fn['ddu#ui#do_action']('preview')
    end,
    opts = ff_opt,
  },
  {
    mode = "n",
    lhs = [[q]],
    rhs = function()
      vim.fn['ddu#ui#do_action']('quit')
    end,
    opts = ff_opt,
  },
  {
    mode = "n",
    lhs = [[<ESC>]],
    rhs = function()
      vim.fn['ddu#ui#do_action']('quit')
    end,
    opts = ff_opt
  },
  {
    mode = "n",
    lhs = [[j]],
    rhs = function()
      if vim.fn.line('.') == vim.fn.line('$') then
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
      if vim.fn.line('.') == 1 then
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
      vim.fn['ddu#ui#do_action']('toggleAllItems')
      vim.fn['ddu#ui#do_action']('itemAction', { name = [[quickfix]] })
    end,
    opts = ff_opt,
  },
  {
    mode = "n",
    lhs = [[y]],
    rhs = function()
      vim.fn['ddu#ui#do_action']('yank')
      print('Yank path the "' .. vim.fn.getreg('+') .. '"')
    end,
    opts = ff_opt,
  },
})
-- }}}

-- lua_ddu-ff-filter {{{
local filter_opt = { buffer = true, noremap = true }
require('user.utils').keymaps_set({
  -- filter insert mode
  {
    mode = "i",
    lhs = [[<CR>]],
    rhs = function()
      vim.cmd('stopinsert')
      vim.fn['ddu#ui#do_action']('closeFilterWindow')
    end,
    opts = filter_opt,
  },
  {
    mode = "i",
    lhs = [[jj]],
    rhs = function()
      vim.cmd('stopinsert')
      vim.fn['ddu#ui#do_action']('closeFilterWindow')
    end,
    opts = filter_opt,
  },
  {
    mode = "i",
    lhs = [[<ECS>]],
    rhs = function()
      vim.cmd('stopinsert')
      vim.fn['ddu#ui#do_action']('closeFilterWindow')
    end,
    opts = filter_opt,
  },

  -- filter normal mode
  {
    mode = "n",
    lhs = [[q]],
    rhs = function()
      vim.fn['ddu#ui#do_action']('closeFilterWindow')
    end,
    opts = filter_opt,
  },
  {
    mode = "n",
    lhs = [[<CR>]],
    rhs = function()
      vim.fn['ddu#ui#do_action']('closeFilterWindow')
    end,
    opts = filter_opt,
  },
  {
    mode = "n",
    lhs = [[j]],
    rhs = function()
      vim.fn['ddu#ui#do_action']('closeFilterWindow')
    end,
    opts = filter_opt,
  },
  {
    mode = "n",
    lhs = [[<ESC>]],
    rhs = function()
      vim.fn['ddu#ui#do_action']('closeFilterWindow')
    end,
    opts = filter_opt,
  },
})
-- }}}
