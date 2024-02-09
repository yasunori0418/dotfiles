local M = {}
local joinpath = vim.fs.joinpath

---@diagnostic disable: duplicate-doc-alias
---@alias plugin_add_type
---| "prepend"
---| "append"

---初回起動時にプラグインのダウンロードとruntimepathに追加する
---@param repo string user_name/plugin_name
---@param host? string default: "github.com"
---@param type? plugin_add_type default: "prepend"
local function init_plugin(repo, host, type)
    host = host or "github.com"
    type = type or "prepend"
    local repo_path = joinpath(host, repo)
    local repo_dir = joinpath(vim.g.dpp_cache, "repos", repo_path)
    if not vim.uv.fs_stat(repo_dir) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://" .. repo_path,
            repo_dir,
        })
    end
    if type == "prepend" then
        vim.opt.runtimepath:prepend(repo_dir)
    else
        vim.opt.runtimepath:append(repo_dir)
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

local function auto_install_plugins(dpp)
    local notInstallPlugins = vim.iter(vim.tbl_values(dpp.get()))
        :filter(function(p)
            return vim.fn.isdirectory(p.rtp) == 0
        end)
        :totable()
    if #notInstallPlugins > 0 then
        vim.fn["denops#server#wait_async"](function()
            dpp.async_ext_action("installer", "install")
        end)
        vim.api.nvim_create_autocmd("User", {
            pattern = "Dpp:makeStatePost",
            group = M.rc_autocmds,
            callback = function()
                vim.cmd.quit({ bang = true })
            end,
        })
    end
end

local function make_state(dpp)
    dpp.make_state(vim.g.dpp_cache, joinpath(vim.g.base_dir, "dpp", "config.ts"), vim.g.nvim_appname)
    vim.api.nvim_create_autocmd("User", {
        pattern = "Dpp:makeStatePost",
        group = M.rc_autocmds,
        callback = function()
            dpp.load_state(vim.g.dpp_cache)
            auto_install_plugins(dpp)
        end,
        once = true,
        nested = true,
    })
end

local function dpp_setup()
    local dpp = require("dpp")
    if dpp.load_state(vim.g.dpp_cache) > 0 then
        vim.fn["denops#server#wait_async"](function()
            make_state(dpp)
        end)
    else
        auto_install_plugins(dpp)
        vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = gather_check_files(),
            group = M.rc_autocmds,
            callback = function()
                vim.notify("dpp check_files() is run", vim.log.levels.INFO)
                dpp.check_files()
            end,
        })
    end
    vim.api.nvim_create_autocmd("User", {
        pattern = "Dpp:makeStatePost",
        group = M.rc_autocmds,
        callback = function()
            vim.notify("dpp make_state() is done", vim.log.levels.INFO)
        end,
    })
end

---init.luaで呼び出すdpp.vimの初期設定
---NVIM_APPNAMEを使ってプロファイルとして分離してみる
---NVIM_APPNAMEが設定されていない場合は、デフォルトの`nvim`になる
function M.setup()
    vim.g.nvim_appname = vim.env.NVIM_APPNAME or "nvim"
    if vim.g.nvim_appname == "nvim" then
        vim.g.dpp_cache = joinpath(vim.env.XDG_CACHE_HOME, "dpp")
    else
        vim.g.dpp_cache = joinpath(vim.env.XDG_CACHE_HOME, vim.g.nvim_appname .. "_dpp")
    end

    vim.g.base_dir = joinpath(vim.env.XDG_CONFIG_HOME, vim.g.nvim_appname)
    vim.env.BASE_DIR = vim.g.base_dir
    vim.g.hooks_dir = joinpath(vim.g.base_dir, "hooks")
    vim.env.HOOKS_DIR = vim.g.hooks_dir
    vim.g.snippet_dir = joinpath(vim.g.base_dir, "snippets")
    vim.g.rc_dir = joinpath(vim.g.base_dir, "rc")
    vim.g.toml_dir = joinpath(vim.g.base_dir, "toml")
    M.rc_autocmds = vim.api.nvim_create_augroup("RcAutocmds", { clear = true })

    init_plugin("Shougo/dpp-ext-lazy")
    init_plugin("Shougo/dpp-ext-toml")
    init_plugin("Shougo/dpp-ext-installer")
    init_plugin("Shougo/dpp-protocol-git")
    init_plugin("Shougo/dpp.vim")
    init_plugin("vim-denops/denops.vim")
    dpp_setup()
end

return M
