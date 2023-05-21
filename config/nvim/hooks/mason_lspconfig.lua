-- lua_add {{{
local opt = { noremap = true, silent = true }
require('user.utils').keymaps_set({
  { mode = {"n"}, lhs = [[ l]], rhs = [[<Plug>(lsp)]], opts = {} },
  { mode = {"n"}, lhs = [[<Plug>(lsp)k]], rhs = [[<Cmd>Lspsaga hover_doc<CR>]], opts = opt },
  { mode = {"n"}, lhs = [[<Plug>(lsp)K]], rhs = [[<Cmd>Lspsaga lsp_finder<CR>]], opts = opt },
  { mode = {"n"}, lhs = [[<Plug>(lsp)r]], rhs = [[<Cmd>Lspsaga rename<CR>]], opts = opt },
  { mode = {"n"}, lhs = [[<Plug>(lsp)o]], rhs = [[<Cmd>Lspsaga outline<CR>]], opts = opt },
  { mode = {"n"}, lhs = [[<Plug>(lsp)c]], rhs = [[<Cmd>Lspsaga code_action<CR>]], opts = opt },
  { mode = {"n"}, lhs = [[<Plug>(lsp)h]], rhs = vim.lsp.buf.signature_help, opts = opt },
  { mode = {"n"}, lhs = [[<Plug>(lsp)f]], rhs = vim.lsp.buf.format, opts = opt },
  { mode = {"n"}, lhs = [[<Plug>(lsp)i]], rhs = vim.lsp.buf.implementation, opts = opt },
  { mode = {"n"}, lhs = [[<Plug>(lsp)e]], rhs = [[<Cmd>Lspsaga show_line_diagnostics<CR>]], opts = opt },
  { mode = {"n"}, lhs = [[<Plug>(lsp)E]], rhs = [[<Cmd>Lspsaga show_cursor_diagnostics<CR>]], opts = opt },
  { mode = {"n"}, lhs = [[<Plug>(lsp)q]], rhs = [[<Cmd>Lspsaga show_buf_diagnostics<CR>]], opts = opt },
  { mode = {"n"}, lhs = [[gd]], rhs = [[<Cmd>Lspsaga peek_definition<CR>]], opts = opt },
  { mode = {"n"}, lhs = [[gD]], rhs = vim.lsp.buf.declaration, opts = opt },
  { mode = {"n"}, lhs = [=[[d]=], rhs = [[<Cmd>Lspsaga diagnostic_jump_prev<CR>]], opts = opt },
  { mode = {"n"}, lhs = [=[]d]=], rhs = [[<Cmd>Lspsaga diagnostic_jump_next<CR>]], opts = opt },
})
-- }}}

-- lua_source {{{
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
--local keymap = vim.keymap.set
local lsp = vim.lsp -- nvim lsp api.
--local diag = vim.diagnostic -- nvim diagnostic api.

mason_lspconfig.setup({
  ensure_installed = {
    "lua_ls",
    "intelephense",
    "pyright",
    -- "yamlls",
    "bashls",
  },
  automatic_installation = true,
})

mason_lspconfig.setup_handlers({
  function(server_name)
    local lsp_options = {}

    local capabilities = lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    if server_name == "lua_ls" then
      lsp_options.capabilities = capabilities
    end

    lspconfig[server_name].setup(lsp_options)
  end,
})
-- }}}
