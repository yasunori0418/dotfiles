local null_ls = require('null-ls')

local code_actions = null_ls.builtins.code_actions
local completion = null_ls.builtins.completion
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting
--local hover = null_ls.builtins.hover

local sources = {
  code_actions.gitsigns,
  completion.vsnip,
  formatting.stylua,
  formatting.taplo,
  diagnostics.vint,
  diagnostics.textlint.with({
    filetypes = { 'markdown' },
    prefer_local = 'node_modules/.bin',
  }),
}

null_ls.setup({
  border = 'single',
  diagnostics_format = '[#{c}] #{m} (#{s})',
  sources = sources,
})
