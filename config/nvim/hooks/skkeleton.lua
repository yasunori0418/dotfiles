-- lua_add {{{
vim.keymap.set({"i", "c"}, [[<C-j>]], [[<Plug>(skkeleton-toggle)]], {noremap = false})
-- }}}

-- lua_source {{{
local skkeleton_autocmds = vim.api.nvim_create_augroup('skkeleton_autocmds', { clear = true })
require('user.utils').autocmds_set{
  { -- skkeleton-initialize-pre
    events = "User",
    pattern = "skkeleton-initialize-pre",
    group = skkeleton_autocmds,
    callback = function()
      vim.fn['vimrc#skkeleton_init']()
    end,
  },
  {
    events = "User",
    pattern = "skkeleton-enable-pre",
    group = skkeleton_autocmds,
    callback = function()
      vim.fn['vimrc#skkeleton_pre']()
    end,
  },
  {
    events = "User",
    pattern = "skkeleton-disable-pre",
    group = skkeleton_autocmds,
    callback = function()
      vim.fn['vimrc#skkeleton_post']()
    end,
  },
  {
    events = "InsertLeave",
    pattern = "*",
    group = skkeleton_autocmds,
    callback = function()
      vim.cmd[[mode]]
    end,
  },
}
-- }}}
