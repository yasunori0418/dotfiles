-- lua_add {{{
local opt = { noremap = true, silent = true }
local lsp_function = vim.lsp
local diagnostic = vim.diagnostic
require("user.utils").keymaps_set({
  { mode = { "n" }, lhs = [[mk]],   rhs = lsp_function.buf.hover,          opts = opt },
  { mode = { "n" }, lhs = [[ma]],   rhs = lsp_function.buf.code_action,    opts = opt },
  { mode = { "n" }, lhs = [[mr]],   rhs = lsp_function.buf.rename,         opts = opt },
  { mode = { "n" }, lhs = [[gq]],   rhs = lsp_function.buf.format,         opts = opt },
  { mode = { "n" }, lhs = [[gi]],   rhs = lsp_function.buf.implementation, opts = opt },
  { mode = { "n" }, lhs = [[gd]],   rhs = lsp_function.buf.definition,     opts = opt },
  { mode = { "n" }, lhs = [[gD]],   rhs = lsp_function.buf.declaration,    opts = opt },
  { mode = { "n" }, lhs = [[ge]],   rhs = diagnostic.open_float,           opts = opt },
  { mode = { "n" }, lhs = [=[[d]=], rhs = diagnostic.goto_prev,            opts = opt },
  { mode = { "n" }, lhs = [=[]d]=], rhs = diagnostic.goto_next,            opts = opt },
})
-- }}}

-- lua_source {{{
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
local lsp = vim.lsp -- nvim lsp api.

mason_lspconfig.setup({
  ensure_installed = {
    "lua_ls",
    "intelephense",
    "pyright",
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
