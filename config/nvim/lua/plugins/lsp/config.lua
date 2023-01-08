local mason_lspconfig = require('mason-lspconfig')
local lspconfig = require("lspconfig")
--local keymap = vim.keymap.set
local lsp = vim.lsp -- nvim lsp api.
--local diag = vim.diagnostic -- nvim diagnostic api.

mason_lspconfig.setup({
  ensure_installed = {
    'sumneko_lua',
    'intelephense',
    'pyright',
  },
  automatic_installation = true,
})

mason_lspconfig.setup_handlers({ function(server_name)
  local lsp_options = {}

  local capabilities = lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  if server_name == 'sumneko_lua' then
    lsp_options.capabilities = capabilities
  end

  lspconfig[server_name].setup(lsp_options)
end })
