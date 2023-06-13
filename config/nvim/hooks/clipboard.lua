-- lua_add {{{
-- vim.g.loaded_clipboard_provider = true
require('deferred-clipboard').setup({
  fallback = 'unnamedplus',
  lazy = true,
})
-- }}}
