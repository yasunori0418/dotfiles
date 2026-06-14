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
                and not vim.regex(vim.fn.expand([[$HOME/\.config/nvim]])):match_str(v)
                and directory_exists(vim.fs.joinpath(v, "lua"))
        end)
        :totable()
end

---$LUA_PATHからモジュールを収集
---@return string[]
local function gather_lua_path()
    return vim.list.unique(vim.iter(vim.split(vim.env.LUA_PATH, ";", { trimempty = true }))
        :map(function(v)
            return vim.fn.substitute(v, [[\v\/{-}\?.+$]], "", "")
        end)
        :totable())
end

---@return string[]
local function library()
    return vim.iter({
        gather_lua_plugin(),
        gather_runtimepath(),
        gather_lua_path(),
        vim.fn.expand([[$HOME/dotfiles/home/.config/nvim]]),
    })
        :flatten(math.huge)
        :totable()
end

-- emmylua_ls(Neovim クライアント)は `["Lua", "emmylua"]` の順で workspace/configuration を
-- pull し、最後に見つかった非空 scope で上書きする。nvim-lspconfig の base config が
-- `settings.emmylua`(codeLens/hint) を定義しているため、`Lua` scope は常に破棄される。
-- よって設定は emmyrc ネイティブスキーマとして `emmylua` scope に置く必要がある。
-- また `on_init` は didChangeConfiguration 送信より後に走り初回 pull に間に合わないため、
-- library は静的な settings で渡す(after/lsp はluaバッファ初回アタッチ時=startup後に評価され、
-- その時点で dpp プラグイン・runtimepath は揃っている)。
---@type vim.lsp.Config
return {
    settings = {
        emmylua = {
            runtime = { version = "LuaJIT" },
            workspace = {
                library = library(),
                ignoreDir = {
                    ".vscode",
                    ".devenv",
                },
            },
            format = {
                externalTool = {
                    program = "stylua",
                    args = {
                        "-",
                        "--config-path=" .. vim.fn.expand("$HOME/dotfiles/stylua.toml"),
                        "--stdin-filepath=${file}",
                        "--color=Never",
                        "--range-start=${start_offset}",
                        "--range-end=${end_offset}",
                    },
                    timeout = 5000,
                },
            },
        },
    },
    workspace_required = true,
}
