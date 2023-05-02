-- lua_add {{{
local co = require('user.utils').conditional_operator
local keymaps_set = require('user.utils').keymaps_set

local opt = { silent = true, noremap = false }
local opt_expr = { silent = true, noremap = false, expr = true }
keymaps_set{
  { mode = {"n"}, lhs = [[gc]], rhs = [[<Plug>(comment_toggle_linewise)]],          opts = opt },
  { mode = {"n"}, lhs = [[gb]], rhs = [[<Plug>(comment_toggle_blockwise)]],         opts = opt },
  { mode = {"x"}, lhs = [[gc]], rhs = [[<Plug>(comment_toggle_linewise_visual)]],   opts = opt },
  { mode = {"x"}, lhs = [[gb]], rhs = [[<Plug>(comment_toggle_blockwise)]],         opts = opt },
  {
    mode = {"n"},
    lhs = [[gcc]],
    rhs = function()
      return co{
        c = vim.v.count == 0,
        t = [[<Plug>(comment_toggle_linewise_current)]],
        f = [[<Plug>(comment_toggle_linewise_count)]]
      }
    end,
    opts = opt_expr,
  },
  {
    mode = {"n"},
    lhs = [[gbc]],
    rhs = function()
      return co{
        c = vim.v.count == 0,
        t = [[<Plug>(comment_toggle_blockwise_current)]],
        f = [[<Plug>(comment_toggle_blockwise_count)]]
      }
    end,
    opts = opt_expr,
  },
}
-- }}}
