-- lua_source {{{
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
local lsp = vim.lsp -- nvim lsp api.
local diagnostic = vim.diagnostic
local utils = require("user.utils")
local user_lsp = require("user.lsp")

mason_lspconfig.setup({
  ensure_installed = {
    "lua_ls",
    "intelephense",
    "pyright",
  },
  automatic_installation = true,
})

user_lsp.on_attach(function(_, buffer)
  local opt = { noremap = true, silent = true, buffer = buffer }
  utils.keymaps_set({
    { mode = { "n" }, lhs = [[K]],    rhs = lsp.buf.hover,         opts = opt },
    { mode = { "n" }, lhs = [[ma]],   rhs = lsp.buf.code_action,   opts = opt },
    { mode = { "n" }, lhs = [[gq]],   rhs = user_lsp.format,       opts = opt },
    { mode = { "n" }, lhs = [[gr]],   rhs = lsp.buf.rename,        opts = opt },
    { mode = { "n" }, lhs = [[gd]],   rhs = lsp.buf.definition,    opts = opt },
    { mode = { "n" }, lhs = [[ge]],   rhs = diagnostic.open_float, opts = opt },
    { mode = { "n" }, lhs = [=[[d]=], rhs = diagnostic.goto_prev,  opts = opt },
    { mode = { "n" }, lhs = [=[]d]=], rhs = diagnostic.goto_next,  opts = opt },
  })
end)

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
