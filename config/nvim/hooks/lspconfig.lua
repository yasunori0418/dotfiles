-- lua_source {{{
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

require("user.lsp.keymaps")

mason_lspconfig.setup({
    ensure_installed = {
        -- "lua_ls",
        -- "pyright",
        -- "intelephense",
        -- "denols",
        -- "efm",
    },
    automatic_installation = false,
})

mason_lspconfig.setup_handlers({
    function(server_name)
        local lsp_options = {}

        lsp_options.capabilities = capabilities

        lspconfig[server_name].setup(lsp_options)
    end,

    lua_ls = require("user.lsp.lua_ls"),
    pyright = require("user.lsp.pyright"),
    denols = require("user.lsp.denols"),
    efm = require("user.lsp.efm"),
})
-- }}}
