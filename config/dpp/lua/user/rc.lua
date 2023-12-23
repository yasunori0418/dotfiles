local M = {}
local joinpath = vim.fs.joinpath

---@alias plugin_add_type
---| "prepend"
---| "append"

---初回起動時にプラグインのダウンロードとruntimepathに追加する
---@param repo string user_name/plugin_name
---@param host? string default: github.com
---@param type? plugin_add_type user_name/plugin_name
local function plugin_add(repo, host, type)
    host = host or "github.com"
    type = type or "prepend"
    local repo_dir = joinpath(M.dpp_dir, "repos", host, repo)
    local plugin_name = vim.fn.split(repo, "/")[2]
    if not vim.regex("/" .. plugin_name):match_str(vim.o.runtimepath) then
        if vim.fn.isdirectory(repo_dir) ~= 1 then
            os.execute("git clone https://" .. host .. "/" .. repo .. " " .. repo_dir)
        end
        if type == "prepend" then
            vim.opt.runtimepath:prepend(repo_dir)
        else
            vim.opt.runtimepath:append(repo_dir)
        end
    end
end

local function dpp_setup()
    local dpp = require("dpp")
    if dpp.load_state(M.dpp_dir) then
        vim.api.nvim_create_autocmd("User", {
            pattern = "DenopsReady",
            callback = function()
                vim.notify("dpp load_state() is failed", vim.log.levels.INFO)
                dpp.make_state(M.dpp_dir, joinpath(vim.g.base_dir, "dpp", "config.ts"))
            end,
        })
    end
end

---init.luaで呼び出すdpp.vimの初期設定
---NVIM_APPNAMEを使ってプロファイルとして分離してみる
---NVIM_APPNAMEが設定されていない場合は、デフォルトの`nvim`になる
function M.setup()
    -- local nvim_appname = vim.env.NVIM_APPNAME or "nvim"
    M.dpp_dir = nil
    -- if nvim_appname == "nvim" then
    M.dpp_dir = joinpath(vim.env.XDG_CACHE_HOME, "dpp")
    -- else
    -- M.dpp_dir = joinpath(vim.env.XDG_CACHE_HOME, nvim_appname .. "_dpp")
    -- end

    vim.g.base_dir = joinpath(vim.env.XDG_CONFIG_HOME, "dpp"--[[ nvim_appname ]])
    vim.env.BASE_DIR = vim.g.base_dir

    -- vim.g.snippet_dir = joinpath(vim.g.base_dir, "snippets")
    vim.g.hooks_dir = joinpath(vim.g.base_dir, "hooks")
    vim.env.HOOKS_DIR = vim.g.hooks_dir
    vim.g.rc_dir = joinpath(vim.g.base_dir, "rc")
    vim.g.toml_dir = joinpath(vim.g.base_dir, "toml")

    plugin_add("Shougo/dpp-ext-lazy")
    plugin_add("Shougo/dpp-ext-toml")
    plugin_add("Shougo/dpp-ext-installer")
    plugin_add("Shougo/dpp-protocol-git")
    plugin_add("Shougo/dpp.vim")
    plugin_add("vim-denops/denops.vim")
    dpp_setup()
end

return M
