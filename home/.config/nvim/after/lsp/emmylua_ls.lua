---@param path string
---@return boolean
local function directory_exists(path)
    local stat = vim.uv.fs_stat(path)
    if stat == nil then
        return false
    end
    return stat.type == "directory"
end

---dppで管理しているプラグイン一覧からluaディレクトリが含まれる物のリストを収集
---@return string[]
local function gather_lua_plugin()
    return vim.iter(vim.tbl_values(require("dpp").get()))
        :filter(function(v)
            return directory_exists(vim.fs.joinpath(v.path, "lua"))
        end)
        :map(function(p)
            return p.path
        end)
        :totable()
end

---runtimepathからdppで管理していない範囲でluaディレクトリがあるファイルパスを収集
---@return string[]
local function gather_runtimepath()
    return vim.iter(vim.api.nvim_get_runtime_file("", true))
        :filter(function(v)
            return not vim.regex(require("user.rc").dpp_base_path):match_str(v)
                and directory_exists(vim.fs.joinpath(v, "lua"))
        end)
        :totable()
end

---@type vim.lsp.Config
return {
    on_init = function(client)
        client.config.settings.Lua --[[@as table]] =
            vim.tbl_deep_extend("force", client.config.settings.Lua --[[@as table]], {
                workspace = {
                    library = vim.iter({ gather_lua_plugin(), gather_runtimepath() }):flatten(math.huge):totable(),
                },
            })
    end,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            workspace = { checkThirdParty = false },
        },
    },
    workspace_required = true,
}
