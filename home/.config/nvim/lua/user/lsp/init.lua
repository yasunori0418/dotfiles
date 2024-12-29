require("user.lsp.keymaps")

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

require("user.lsp.servers.denols")
require("user.lsp.servers.efm")
require("user.lsp.servers.intelephense")
require("user.lsp.servers.lua_ls")
require("user.lsp.servers.nixd")
require("user.lsp.servers.pyright")
-- require("user.lsp.servers.ts_ls")
require("user.lsp.servers.vtsls")
require("user.lsp.servers.yamlls")

utils.config("awk_ls")
utils.config("bashls")
utils.config("ccls")
utils.config("clojure_lsp")
utils.config("cssls")
utils.config("emmet_ls")
utils.config("html")
utils.config("jqls")
utils.config("jsonls")
utils.config("kotlin_language_server")
utils.config("taplo")
