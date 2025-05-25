local M = {}
local joinpath = vim.fs.joinpath

---@class Plugin
---@diagnostic disable :duplicate-doc-field
---@field repo string
---@field host? string

---初回起動時にプラグインのダウンロードとリポジトリのパスを返却する
---runtimepathに追加する
---@param plugin Plugin
---@return string
local function init_plugin(plugin)
    local host = plugin.host or "github.com"
    local repo_path = joinpath(host, plugin.repo)
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
    return repo_dir
end

local function gather_check_files()
    local glob_patterns = {
        "**/*.lua",
        "**/*.toml",
        "**/*.ts",
    }
    local target_directories = vim.iter({ vim.g.base_dir, vim.fn.expand("~/dotfiles/home/.config/nvim") }):join(",")
    local check_files = {}
    for _, glob_pattern in pairs(glob_patterns) do
        table.insert(check_files, vim.fn.globpath(target_directories, glob_pattern, true, true))
    end
    return vim.iter(check_files):flatten():totable()
end

local function auto_install_plugins(dpp)
    local not_install_plugins = vim.iter(vim.tbl_values(dpp.get()))
        :filter(function(p)
            return vim.fn.isdirectory(p.rtp) == 0
        end)
        :totable()
    if #not_install_plugins > 0 then
        vim.fn["denops#server#wait_async"](function()
            dpp.async_ext_action("installer", "install")
        end)
        vim.api.nvim_create_autocmd("User", {
            pattern = "Dpp:makeStatePost",
            group = M.rc_autocmds,
            callback = function()
                vim.cmd.quitall({ bang = true })
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
    local is_state_stale_or_missing = dpp.load_state(vim.g.dpp_cache) --[[@as boolean]]
    if is_state_stale_or_missing then
        vim.fn["denops#server#wait_async"](function()
            make_state(dpp)
        end)
    else
        auto_install_plugins(dpp)
    end
    vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = gather_check_files(),
        group = M.rc_autocmds,
        callback = function()
            vim.notify("dpp check_files() is run", vim.log.levels.INFO)
            dpp.check_files()
        end,
    })
    vim.api.nvim_create_autocmd("User", {
        pattern = "Dpp:makeStatePost",
        group = M.rc_autocmds,
        callback = function()
            vim.notify("dpp make_state() is done", vim.log.levels.INFO)
            if is_state_stale_or_missing then
                vim.cmd.quitall({ bang = true })
            end
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

    ---@type Plugin[]
    local init_plugins = {
        { repo = "Shougo/dpp-ext-lazy" },
        { repo = "Shougo/dpp-ext-toml" },
        { repo = "Shougo/dpp-ext-installer" },
        { repo = "Shougo/dpp-protocol-git" },
        { repo = "Shougo/dpp.vim" },
        { repo = "vim-denops/denops.vim" },
    }
    vim.iter(init_plugins):map(
        ---@param plugin Plugin
        ---@return string
        function(plugin)
            return vim.opt.runtimepath:prepend(init_plugin(plugin))
        end
    )
    dpp_setup()
end

return M
