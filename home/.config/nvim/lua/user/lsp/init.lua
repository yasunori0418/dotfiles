require("user.lsp.keymaps")
require("user.lsp.diagnostic")

local utils = require("user.lsp.utils")
utils.on_attach(function(client, buffer)
    if client == nil then
        return
    end
    if client.server_capabilities.documentSymbolProvider then
        if client.name ~= "efm" then
            require("nvim-navic").attach(client, buffer)
        end
    end
end)

vim.lsp.config("*", {
    capabilities = utils.capabilities,
} --[[@as vim.lsp.Config]])

require("user.lsp.servers.denols")
require("user.lsp.servers.efm")
require("user.lsp.servers.intelephense")
require("user.lsp.servers.lua_ls")
require("user.lsp.servers.nixd")
require("user.lsp.servers.pyright")
-- require("user.lsp.servers.ts_ls")
require("user.lsp.servers.vtsls")
require("user.lsp.servers.yamlls")
require("user.lsp.servers.kotlin_language_server")
require("user.lsp.servers.typos_lsp")

local lspconfig = require("lspconfig")
lspconfig.awk_ls.setup()
lspconfig.bashls.setup()
lspconfig.ccls.setup()
lspconfig.clojure_lsp.setup()
lspconfig.cssls.setup() -- vscode-langservers-extracted
lspconfig.emmet_ls.setup()
lspconfig.html.setup() -- vscode-langservers-extracted
lspconfig.jqls.setup()
lspconfig.jsonls.setup() -- vscode-langservers-extracted
lspconfig.taplo.setup()
-- lspconfig.phpactor.setup()
