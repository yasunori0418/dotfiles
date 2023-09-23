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
    { mode = { "n", "x" }, lhs = [[ l]],           rhs = [[<Plug>(lsp)]],     opts = opt },
    { mode = { "n" },      lhs = [[K]],            rhs = lsp.buf.hover,       opts = opt },
    { mode = { "n" },      lhs = [[<Plug>(lsp)a]], rhs = lsp.buf.code_action, opts = opt },
    { mode = { "n" },      lhs = [[<Plug>(lsp)q]], rhs = user_lsp.format,     opts = opt },
    { mode = { "n" },      lhs = [[<Plug>(lsp)r]], rhs = lsp.buf.rename,      opts = opt },
    { -- ddu lsp:definition_all
      mode = { "n" },
      lhs = [[<Plug>(lsp)D]],
      rhs = function()
        vimx.fn.ddu.start({
          name = "lsp:definition_all",
        })
      end,
      opts = opt,
    },
    { -- ddu lsp:finder
      mode = { "n" },
      lhs = [[<Plug>(lsp)f]],
      rhs = function()
        vimx.fn.ddu.start({
          name = "lsp:finder",
        })
      end,
      opts = opt,
    },
    { -- lsp:definition
      mode = { "n" },
      lhs = [[gd]],
      rhs = function()
        vimx.fn.ddu.start({
          name = "lsp:definition",
        })
      end,
      opts = opt,
    },
    { -- lsp:declaration
      mode = { "n" },
      lhs = [[gD]],
      rhs = function()
        vimx.fn.ddu.start({
          name = "lsp:declaration",
        })
      end,
      opts = opt,
    },
    { -- lsp:typeDefinition
      mode = { "n" },
      lhs = [[gt]],
      rhs = function()
        vimx.fn.ddu.start({
          name = "lsp:typeDefinition",
        })
      end,
      opts = opt,
    },
    { -- lsp:implementation
      mode = { "n" },
      lhs = [[gi]],
      rhs = function()
        vimx.fn.ddu.start({
          name = "lsp:implementation",
        })
      end,
      opts = opt,
    },
    { -- lsp:references
      mode = { "n" },
      lhs = [[gr]],
      rhs = function()
        vimx.fn.ddu.start({
          name = "lsp:references",
        })
      end,
      opts = opt,
    },
    { -- lsp:documentSymbol
      mode = "n",
      lhs = [[<Plug>(lsp)s]],
      rhs = function()
        vimx.fn.ddu.start({
          name = "lsp:documentSymbol",
        })
      end,
      opts = opt,
    },
    { -- lsp:workspaceSymbol
      mode = "n",
      lhs = [[<Plug>(lsp)S]],
      rhs = function()
        vimx.fn.ddu.start({
          name = "lsp:workspaceSymbol",
        })
      end,
      opts = opt,
    },
    { -- lsp:incomingCalls
      mode = "n",
      lhs = [[<Plug>(lsp)c]],
      rhs = function()
        vimx.fn.ddu.start({
          name = "lsp:incomingCalls",
        })
      end,
      opts = opt,
    },
    { -- lsp:outgoingCalls
      mode = "n",
      lhs = [[<Plug>(lsp)C]],
      rhs = function()
        vimx.fn.ddu.start({
          name = "lsp:outgoingCalls",
        })
      end,
      opts = opt,
    },
    { -- lsp:supertypes
      mode = "n",
      lhs = [[<Plug>(lsp)t]],
      rhs = function()
        vimx.fn.ddu.start({
          name = "lsp:supertypes",
        })
      end,
      opts = opt,
    },
    { -- lsp:subtypes
      mode = "n",
      lhs = [[<Plug>(lsp)T]],
      rhs = function()
        vimx.fn.ddu.start({
          name = "lsp:subtypes",
        })
      end,
      opts = opt,
    },
    { -- ddu lsp:codeAction
      mode = { "n", "x" },
      lhs = [[<Plug>(lsp)a]],
      rhs = [[<Cmd>call ddu#start(#{name: "lsp:codeAction"})<CR>]],
      opts = opt,
    },
    { -- ddu lsp:diagnostics
      mode = "n",
      lhs = [[<Plug>(lsp)d]],
      rhs = function()
        vimx.fn.ddu.start({
          name = "lsp:diagnostics",
        })
      end,
      opts = opt,
    },
    { mode = { "n" }, lhs = [[ge]],   rhs = diagnostic.open_float, opts = opt },
    { mode = { "n" }, lhs = [=[[d]=], rhs = diagnostic.goto_prev,  opts = opt },
    { mode = { "n" }, lhs = [=[]d]=], rhs = diagnostic.goto_next,  opts = opt },
  })

  pcall(lsp.inlay_hint, buffer, nil)
end)

local capabilities = require("ddc_nvim_lsp").make_client_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

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
            -- library = vim.api.nvim_get_runtime_file("lua", true),
            maxPreload = 1000,
          },
          completion = {
            callSnippet = "Both",
            enable = true,
            keywordSnippet = "Both",
          },
          hint = {
            enable = true,
          },
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    })
  end,

  pyright = function()
    lspconfig.pyright.setup({
      capabilities = capabilities,
      settings = {
        python = {
          exclude = { ".venv" },
          venvPath = ".",
          venv = ".venv",
        },
      },
    })
  end,

  denols = function()
    lspconfig.denols.setup({
      capabilities = capabilities,
      settings = {
        deno = {
          enable = true,
          unstable = true,
          lint = true,
          suggest = {
            completeFunctionCalls = true,
            autoImports = false,
            imports = {
              hosts = {
                ["https://deno.land"] = true,
                ["https://crux.land"] = true,
                ["https://x.nest.land"] = true,
              },
            },
          },
        },
      },
    })
  end
})
-- }}}
