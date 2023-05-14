-- lua_ddu-filer {{{
local opt = { buffer = true, noremap = true }
local opt_expr = { buffer = true, expr = true, noremap = true }

local do_action = vim.fn['ddu#ui#do_action']
local multi_actions = vim.fn['ddu#ui#multi_actionsdo_action']

vim.g.ddu_ui_filer_prev_dirs = vim.empty_dict()
require('user.utils').keymaps_set({
  {
    mode = "n",
    lhs = [[<CR>]],
    rhs = function()
      if vim.fn['ddu#ui#get_item']()['isTree'] then
        do_action('expandItem', { mode = 'toggle' })
      else
        do_action('itemAction', {
          name = 'open',
          params = { command = 'drop' }
        })
      end
    end,
    opts = opt_expr,
  },
  {
    mode = "n",
    lhs = [[v]],
    rhs = function()
      do_action('itemAction', {
        name = 'open',
        params = { command = 'vsplit' }
      })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[s]],
    rhs = function()
      do_action('itemAction', {
        name = 'open',
        params = { command = 'split' }
      })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[t]],
    rhs = function()
      do_action('itemAction', {
        name = 'open',
        params = { command = 'tabedit' }
      })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[p]],
    rhs = function()
      do_action('preview')
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[C]],
    rhs = function()
      multi_actions({
        { 'itemAction', { name = 'copy' } },
        { 'clearSelectAllItems' },
      })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[M]],
    rhs = function()
      multi_actions({
        { 'itemAction', { name = 'move' } },
        { 'clearSelectAllItems' },
      })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[P]],
    rhs = function()
      do_action('itemAction', { name = 'paste' })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[R]],
    rhs = function()
      do_action('itemAction', { name = 'rename' })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[ d]],
    rhs = [[<Plug>(delete)]],
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[<Plug>(delete)d]],
    rhs = function()
      do_action('itemAction', { name = 'trash' })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[<Plug>(delete)D]],
    rhs = function()
      do_action('itemAction', { name = 'delete' })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[N]],
    rhs = function()
      do_action('itemAction', { name = 'newFile' })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[y]],
    rhs = function()
      do_action('itemAction', { name = 'yank' })
      print('Yank path the "' .. vim.fn.getreg('+') .. '"')
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[~]],
    rhs = function()
      do_action('itemAction', {
        name = 'narrow',
        params = { path = vim.env.HOME }
      })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[a]],
    rhs = function()
      do_action('chooseAction')
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[o]],
    rhs = function()
      do_action('expandItem', {mode = 'toggle'})
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[O]],
    rhs = function()
      do_action('expandItem', {maxLevel = -1})
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[  ]],
    rhs = function()
      do_action('toggleSelectItem')
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[*]],
    rhs = function()
      do_action('toggleAllItems')
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[q]],
    rhs = function()
      do_action('quit')
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[<Esc>]],
    rhs = function()
      do_action('quit')
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[j]],
    rhs = function()
      if vim.fn.line('.') == vim.fn.line('$') then
        return [[ggj]]
      else
        return [[j]]
      end
    end,
    opts = opt_expr,
  },
  {
    mode = "n",
    lhs = [[k]],
    rhs = function()
      if vim.fn.line('.') == 2 then
        return [[G]]
      else
        return [[k]]
      end
    end,
    opts = opt_expr,
  },

  -- ディレクトリ移動系
  -- { -- Filer_parent_dir
  --   mode = "n",
  --   lhs = [[..]],
  --   rhs = function()
  --     if vim.b.ddu_ui_filer_path == '/' then
  --       print('Cannot go back because it is the root directory.')
  --       return
  --     end
  --
  --     if vim.fn.exists(vim.g.ddu_ui_filer_prev_dirs[vim.b.ddu_ui_name]) == 0 then
  --       print(vim.g.ddu_ui_filer_prev_dirs[vim.b.ddu_ui_name])
  --       vim.g.ddu_ui_filer_prev_dirs[vim.b.ddu_ui_name] = {}
  --     end
  --
  --     table.insert(vim.g.ddu_ui_filer_prev_dirs[vim.b.ddu_ui_name], vim.b.ddu_ui_filer_path)
  --     do_action('itemAction', {
  --       name = 'narrow',
  --       params = { path = '..' }
  --     })
  --   end,
  --   opts = opt,
  -- },
  -- { -- Filer_change_dir
  --   mode = "n",
  --   lhs = [[c]],
  --   rhs = function()
  --     if vim.fn.exists('g:ddu_ui_filer_prev_dirs[b:ddu_ui_name]') == 0 then
  --       table.insert(vim.g.ddu_ui_filer_prev_dirs[vim.b.ddu_ui_name], {})
  --     end
  --     table.insert(vim.g.ddu_ui_filer_prev_dirs[vim.b.ddu_ui_name], vim.b.ddu_ui_filer_path)
  --
  --     do_action('itemAction', { name = 'narrow' })
  --   end,
  --   opts = opt,
  -- },
  -- { -- Filer_prev_dir
  --   mode = "n",
  --   lhs = [[b]],
  --   rhs = function()
  --     if vim.fn.exists('g:ddu_ui_filer_prev_dirs[b:ddu_ui_name]') == 0 then
  --       if table.maxn(vim.g.ddu_ui_filer_prev_dirs[vim.b.ddu_ui_name]) == 0 then
  --         print('Not found previous directory.')
  --         return
  --       end
  --     else
  --       print('The directory has not been changed with this filer.')
  --       vim.g.ddu_ui_filer_prev_dirs[vim.b.ddu_ui_name] = {}
  --       return
  --     end
  --
  --     local prev_dir_count = table.maxn(vim.g.ddu_ui_filer_prev_dirs[vim.b.ddu_ui_name])
  --     local prev_dir_path = vim.g.ddu_ui_filer_prev_dirs[vim.b.ddu_ui_name][prev_dir_count]
  --     table.remove(vim.g.ddu_ui_filer_prev_dirs, prev_dir_count)
  --     do_action('itemAction', {
  --       name = 'narrow',
  --       params = { path = prev_dir_path },
  --     })
  --   end,
  --   opts = opt,
  -- },
  -- { -- Filer_first_dir
  --   mode = "n",
  --   lhs = [[f]],
  --   rhs = function()
  --     if vim.fn.exists('g:ddu_ui_filer_prev_dirs[b:ddu_ui_name]') == 0 then
  --       if table.maxn(vim.g.ddu_ui_filer_prev_dirs[vim.b.ddu_ui_name]) == 0 then
  --         print('Not found previous directory.')
  --         return ''
  --       end
  --     else
  --       print('The directory has not been changed with this filer.')
  --       table.maxn(vim.g.ddu_ui_filer_prev_dirs[vim.b.ddu_ui_name], {})
  --       return ''
  --     end
  --
  --     local first_dir = vim.g.ddu_ui_filer_prev_dirs[vim.b.ddu_ui_name][1]
  --     table.maxn(vim.g.ddu_ui_filer_prev_dirs[vim.b.ddu_ui_name], {})
  --     do_action('itemAction', {
  --       name = 'narrow',
  --       params = { path = first_dir },
  --     })
  --   end,
  --   opts = opt,
  -- },
  -- { -- Filer_input_dir
  --   mode = "n",
  --   lhs = [[I]],
  --   rhs = function()
  --     vim.g.ddu_ui_filer_prev_dirs[vim.b.ddu_ui_name] = {}
  --     local input_dir = vim.fn.fnamemodify(
  --       vim.fn.input(
  --         'New cwd: ',
  --         vim.b.ddu_ui_filer_path,
  --         'dir'
  --       ),
  --       ':p'
  --     )
  --     do_action('itemAction', {
  --       name = 'narrow',
  --       params = { path = input_dir }
  --     })
  --   end,
  --   opts = opt,
  -- },
  -- {
  --   mode = "n",
  --   lhs = [[l]],
  --   rhs = function()
  --     do_action('cursorNext')
  --   end,
  --   opts = opt,
  -- },
  -- {
  --   mode = "n",
  --   lhs = [[h]],
  --   rhs = function()
  --     do_action('cursorPrevious')
  --   end,
  --   opts = opt,
  -- },
  -- {
  --   mode = "n",
  --   lhs = [[]],
  --   rhs = function()
  --   end,
  --   opts = opt,
  -- },
})

-- }}}
