local M = {}
local joinpath = vim.fs.joinpath

---@diagnostic disable: duplicate-doc-alias
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

local function gather_check_files()
    local glob_patterns = {
        "**/*.lua",
        "**/*.toml",
        "**/*.ts",
    }
    local check_files = {}
    for _, glob_pattern in pairs(glob_patterns) do
        table.insert(check_files, vim.fn.globpath(vim.g.base_dir, glob_pattern, true, true))
        table.insert(check_files, vim.fn.globpath("~/dotfiles/config/nvim", glob_pattern, true, true))
    end
    return vim.tbl_flatten(check_files)
end

local function dpp_setup()
    local dpp = require("dpp")
    local rc_autocmds = vim.api.nvim_create_augroup("RcAutocmds", { clear = true })
    if dpp.load_state(M.dpp_dir) > 0 then
        dpp.make_state(M.dpp_dir, joinpath(vim.g.base_dir, "dpp", "config.ts"), M.nvim_appname)
        vim.api.nvim_create_autocmd("User", {
            pattern = "Dpp:makeStatePost",
            group = rc_autocmds,
            callback = function()
                dpp.load_state(M.dpp_dir)
            end,
            once = true,
            nested = true,
        })
    else
        vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = gather_check_files(),
            group = rc_autocmds,
            callback = function()
                vim.notify("dpp check_files() is run", vim.log.levels.INFO)
                dpp.check_files()
            end,
        })
    end
    local notInstallPlugins = vim.iter(vim.tbl_values(vim.g["dpp#_plugins"]))
        :filter(function(p)
            return vim.fn.isdirectory(p.rtp) == 0
        end)
        :totable()
    if #notInstallPlugins > 0 then
        vim.fn["denops#server#wait_async"](function()
            dpp.async_ext_action("installer", "install")
        end)
    end
    vim.api.nvim_create_autocmd("User", {
        pattern = "Dpp:makeStatePost",
        group = rc_autocmds,
        callback = function()
            vim.notify("dpp make_state() is done", vim.log.levels.INFO)
        end,
    })
end

---init.luaで呼び出すdpp.vimの初期設定
---NVIM_APPNAMEを使ってプロファイルとして分離してみる
---NVIM_APPNAMEが設定されていない場合は、デフォルトの`nvim`になる
function M.setup()
    M.nvim_appname = vim.env.NVIM_APPNAME or "nvim"
    if M.nvim_appname == "nvim" then
        M.dpp_dir = joinpath(vim.env.XDG_CACHE_HOME, "dpp")
    else
        M.dpp_dir = joinpath(vim.env.XDG_CACHE_HOME, M.nvim_appname .. "_dpp")
    end

    vim.g.base_dir = joinpath(vim.env.XDG_CONFIG_HOME, M.nvim_appname)
    vim.env.BASE_DIR = vim.g.base_dir

    vim.g.hooks_dir = joinpath(vim.g.base_dir, "hooks")
    vim.env.HOOKS_DIR = vim.g.hooks_dir
    vim.g.snippet_dir = joinpath(vim.g.base_dir, "snippets")
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
