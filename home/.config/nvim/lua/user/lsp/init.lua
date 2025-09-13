require("user.lsp.keymaps")
require("user.lsp.diagnostic")

local utils = require("user.lsp.utils")
utils.on_attach(function(client, buffer)
    if client == nil or client.server_capabilities == nil then
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

vim.lsp.enable({
    "awk_ls",
    "bashls",
    "ccls",
    "clojure_lsp",
    "cssls", -- vscode-langservers-extracted
    "denols",
    "efm",
    "emmet_ls",
    "emmylua_ls",
    "html", -- vscode-langservers-extracted
    "intelephense",
    "jqls",
    "jsonls", -- vscode-langservers-extracted
    "kotlin_lsp",
    -- "lua_ls",
    "nixd",
    "pyright",
    "taplo",
    "terraformls",
    "ts_query_ls",
    "typos_lsp",
    "vtsls",
    "yamlls",
    -- "kotlin_language_server",
    -- "phpactor",
    -- "ts_ls",
})
