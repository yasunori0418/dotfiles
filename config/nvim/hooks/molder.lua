-- lua_add {{{
require('user.utils').autocmd_set(
  "BufEnter",
  "*",
  function()
    require('user.plugins.molder').init()
  end,
  vim.api.nvim_create_augroup('vimrc_molder', { clear = true })
)
-- }}}

-- lua_source {{{
vim.g.molder_show_hidden = true
-- }}}

-- lua_molder {{{
local opt = { buffer = true, noremap = false }
require('user.utils').keymaps_set{
  { mode = {"n"}, lhs = [[..]], rhs = [[<Plug>(molder-up)]], opts = opt },
  { mode = {"n"}, lhs = [[<C-l>]], rhs = [[<Plug>(molder-reload)]], opts = opt },
  { mode = {"n"}, lhs = [[N]], rhs = [[<Plug>(molder-operations-newdir)]], opts = opt },
  { mode = {"n"}, lhs = [[D]], rhs = [[<Plug>(molder-operations-delete)]], opts = opt },
  { mode = {"n"}, lhs = [[R]], rhs = [[<Plug>(molder-operations-rename)]], opts = opt },
  { mode = {"n"}, lhs = [[S]], rhs = [[<Plug>(molder-operations-shell)]], opts = opt },
  { mode = {"n"}, lhs = [[!]], rhs = [[<Plug>(molder-operations-command)]], opts = opt },
  { mode = {"n"}, lhs = [[C]], rhs = vim.fn['vimrc#molder_change_cwd'], opts = opt },
}
-- }}}
