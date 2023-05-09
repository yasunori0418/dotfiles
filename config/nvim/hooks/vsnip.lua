-- lua_source {{{
vim.g.vsnip_extra_mapping = false
vim.g.vsnip_snippet_dir = vim.g.base_dir .. '/snippet/vsnip'
vim.g.vsnip_snippet_dirs = { vim.g.base_dir .. '/snippet/vsnip/friendly-snippets/snippets', }
vim.g.vsnip_filetypes = vim.empty_dict()

local utils = require('user.utils')
utils.autocmds_set{
  {
    group = utils.vimrc_augroup,
    events = 'User',
    pattern = 'PumCompleteDone',
    callback = function()
      vim.fn['vsnip_integ#on_complete_done'](vim.g['pum#completed_item'])
    end,
  },
  {
    group = utils.vimrc_augroup,
    events = 'InsertEnter',
    pattern = '~/dotfiles/config/nvim/toml/*.toml',
    callback = function()
      vim.g.vsnip_filetypes.toml = { vim.fn['context_filetype#get_filetype']() }
    end,
  },
}

local opt_expr = { noremap = false, expr = true }
utils.keymaps_set{
  {
    mode = {"i", "s"},
    lhs = [[<Tab>]],
    rhs = function()
      if vim.fn['vsnip#jumpable'](1) then
        return [[<Plug>(vsnip-jump-next)]]
      else
        return [[<Tab>]]
      end
    end,
    opts = opt_expr
  },
  {
    mode = {"i", "s"},
    lhs = [[<S-Tab>]],
    rhs = function()
      if vim.fn['vsnip#jumpable'](1) then
        return [[<Plug>(vsnip-jump-prev)]]
      else
        return [[<S-Tab>]]
      end
    end,
    opts = opt_expr,
  },
}
-- }}}
