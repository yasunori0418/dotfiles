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
    'taplo',
  },
  automatic_installation = true,
})

mason_lspconfig.setup_handlers({ function(server_name)
  local lsp_options = {}

--  lsp_options.on_attach = function(client, bufnr)
--    local keymap_options = {
--      noremap = true,
--      --silent = true,
--      --buffer = bufnr,
--    }
--
--    -- About <lsp> prefix ~/dotfiles/config/nvim/rc/keybinds.vim:89
--    keymap('n', '<lsp>k', '<Cmd>Lspsaga hover_doc<CR>', keymap_options)
--    keymap('n', '<lsp>K', '<Cmd>Lspsaga lsp_finder<CR>', keymap_options)
--    keymap('n', '<lsp>r', '<Cmd>Lspsaga rename<CR>', keymap_options)
--    keymap('n', '<lsp>o', '<Cmd>LSoutlineToggle<CR>', keymap_options)
--    keymap({ 'n', 'x' }, '<lsp>c', '<Cmd>Lspsaga code_action<CR>', keymap_options)
--    keymap('n', '<lsp>h', lsp.buf.signature_help, keymap_options)
--    keymap('n', '<lsp>f', lsp.buf.format, keymap_options)
--    keymap('n', '<lsp>i', lsp.buf.implementation, keymap_options)
--    keymap('n', '<lsp>d', '<Cmd>Lspsaga peek_definition<CR>', keymap_options)
--    keymap('n', '<lsp>D', lsp.buf.declaration, keymap_options)
--    keymap('n', '<lsp>E', '<Cmd>Lspsaga show_cursor_diagnostics<CR>', keymap_options)
--    keymap('n', '<lsp>e', '<Cmd>Lspsaga show_line_diagnostics<CR>', keymap_options)
--    keymap('n', '<lsp>q', diag.setloclist, keymap_options)
--    keymap('n', '[d', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', keymap_options)
--    keymap('n', ']d', '<Cmd>Lspsaga diagnostic_jump_next<CR>', keymap_options)
--  end

  local capabilities = lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  if server_name == 'sumneko_lua' then
    lsp_options.capabilities = capabilities
  end

  lspconfig[server_name].setup(lsp_options)
end })
