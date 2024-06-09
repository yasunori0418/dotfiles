local function library()
    local dpp = require("dpp")
    local paths = {}
    for _, plugin in pairs(dpp.get()) do
        table.insert(paths, plugin.path .. "/lua")
    end
    table.insert(paths, vim.fn.stdpath("config") .. "/lua")
    table.insert(paths, vim.env.VIMRUNTIME .. "/lua")
    table.insert(paths, "${3rd}/luv/library")
    table.insert(paths, "${3rd}/busted/library")
    table.insert(paths, "${3rd}/luassert/library")
    return paths
end

return function()
    require("lspconfig").lua_ls.setup({
        capabilities = require("user.lsp.utils").capabilities,
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using
                    -- (most likely LuaJIT in the case of Neovim)
                    pathStrict = true,
                    version = "LuaJIT",
                    path = { "?.lua", "?/init.lua" },
                },
                workspace = {
                    checkThirdParty = false,
                    library = library(),
                    -- maxPreload = 1000,
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
                format = {
                    -- because use stylua from efm.
                    enable = false,
                },
            },
        },
    })
end
