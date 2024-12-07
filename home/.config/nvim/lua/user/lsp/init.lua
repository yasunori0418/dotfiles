require("user.lsp.keymaps")

require("user.lsp.utils").on_attach(function(client, buffer)
    if client == nil then
        return
    end
    if client.server_capabilities.documentSymbolProvider then
        if client.name ~= "efm" then
            require("nvim-navic").attach(client, buffer)
        end
    end
end)

require("user.lsp.servers.lua_ls")
require("user.lsp.servers.pyright")
require("user.lsp.servers.efm")
require("user.lsp.servers.denols")
require("user.lsp.servers.nixd")
require("user.lsp.servers.bashls")
require("user.lsp.servers.intelephense")
require("user.lsp.servers.cssls")
require("user.lsp.servers.html")
require("user.lsp.servers.emmet_ls")
require("user.lsp.servers.awk_ls")
-- require("user.lsp.servers.ts_ls")
require("user.lsp.servers.vtsls")
require("user.lsp.servers.clojure_lsp")
require("user.lsp.servers.yamlls")
require("user.lsp.servers.ccls")
require("user.lsp.servers.jsonls")
require("user.lsp.servers.taplo")
