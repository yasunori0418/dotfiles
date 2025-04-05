local function library()
    local dpp = require("dpp")
    local lua_joinpath = function(path)
        return vim.fs.joinpath(path, "lua")
    end
    local paths = vim.iter(vim.tbl_values(dpp.get()))
        :filter(function(plugin)
            return vim.fn.isdirectory(lua_joinpath(plugin.path) --[[@as string]]) > 0
        end)
        :map(function(plugin)
            return lua_joinpath(plugin.path)
        end)
        :totable()
    for _, value in ipairs({
        lua_joinpath(vim.fn.stdpath("config")),
        lua_joinpath(vim.env.VIMRUNTIME),
        "${3rd}/luv/library",
        "${3rd}/busted/library",
        "${3rd}/luassert/library",
    }) do
        table.insert(paths, value)
    end
    return paths
end

require("lspconfig").lua_ls.setup({
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
                ignoreDir = {
                    ".vscode",
                    ".devenv",
                },
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
} --[[@as vim.lsp.Config]])
