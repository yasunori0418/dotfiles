-- lua_source {{{
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
local lsp = vim.lsp -- nvim lsp api.
local diagnostic = vim.diagnostic
local utils = require("user.utils")
local user_lsp = require("user.lsp")
local vimx = require("artemis")

mason_lspconfig.setup({
  ensure_installed = {
    "lua_ls",
    "intelephense",
    "pyright",
    "denols",
  },
  automatic_installation = true,
})

user_lsp.on_attach(function(_, buffer)
  local opt = { noremap = true, silent = true, buffer = buffer }
  utils.keymaps_set({
    { mode = { "n" }, lhs = [[ l]],           rhs = [[<Plug>(lsp)]],     opts = opt },
    { mode = { "n" }, lhs = [[K]],            rhs = lsp.buf.hover,       opts = opt },
    { mode = { "n" }, lhs = [[<Plug>(lsp)a]], rhs = lsp.buf.code_action, opts = opt },
    { mode = { "n" }, lhs = [[<Plug>(lsp)q]], rhs = user_lsp.format,     opts = opt },
    { mode = { "n" }, lhs = [[<Plug>(lsp)r]], rhs = lsp.buf.rename,      opts = opt },
    {
      mode = { "n" },
      lhs = [[gd]],
      rhs = function()
        vimx.fn.ddu.start({
          name = "lsp:definition",
        })
      end,
      opts = opt,
    },
    {
      mode = { "n" },
      lhs = [[gD]],
      rhs = function()
        vimx.fn.ddu.start({
          name = "lsp:declaration",
        })
      end,
      opts = opt,
    },
    {
      mode = { "n" },
      lhs = [[gt]],
      rhs = function()
        vimx.fn.ddu.start({
          name = "lsp:typeDefinition",
        })
      end,
      opts = opt,
    },
    {
      mode = { "n" },
      lhs = [[gi]],
      rhs = function()
        vimx.fn.ddu.start({
          name = "lsp:implementation",
        })
      end,
      opts = opt,
    },
    {
      mode = { "n" },
      lhs = [[gr]],
      rhs = function()
        vimx.fn.ddu.start({
          name = "lsp:references",
        })
      end,
      opts = opt,
    },
    {
      mode = "n",
      lhs = [[<Plug>(lsp)s]],
      rhs = function()
        vimx.fn.ddu.start({
          name = "lsp:documentSymbol",
        })
      end,
      opts = opt,
    },
    {
      mode = "n",
      lhs = [[<Plug>(lsp)S]],
      rhs = function()
        vimx.fn.ddu.start({
          name = "lsp:workspaceSymbol",
        })
      end,
      opts = opt,
    },
    { mode = { "n" }, lhs = [[ge]],   rhs = diagnostic.open_float, opts = opt },
    { mode = { "n" }, lhs = [=[[d]=], rhs = diagnostic.goto_prev,  opts = opt },
    { mode = { "n" }, lhs = [=[]d]=], rhs = diagnostic.goto_next,  opts = opt },
  })
end)

local capabilities = lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

mason_lspconfig.setup_handlers({
  function(server_name)
    local lsp_options = {}

    lsp_options.capabilities = capabilities

    lspconfig[server_name].setup(lsp_options)
  end,

  lua_ls = function()
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          workspace = {
            checkThirdParty = false,
            library = vim.api.nvim_get_runtime_file("lua", true),
            maxPreload = 1000,
          },
          completion = {
            callSnippet = "Both",
            enable = true,
            keywordSnippet = "Both",
          },
        },
      },
    })
  end,
})
-- }}}
