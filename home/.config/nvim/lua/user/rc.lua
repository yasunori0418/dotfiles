local M = {}
local joinpath = vim.fs.joinpath

---@class Directories
---@diagnostic disable :duplicate-doc-field
---@field base string
---@field toml string
---@field rc string

---@class ExtraArgs
---@diagnostic disable :duplicate-doc-field
---@field neovide boolean
---@field directories Directories

---@class Plugin
---@diagnostic disable :duplicate-doc-field
---@field repo string
---@field host? string

---初回起動時にプラグインのダウンロードとリポジトリのパスを返却する
---@param plugin Plugin
---@return string
local function init_plugin(plugin)
    local host = plugin.host or "github.com"
    local repo_path = joinpath(host, plugin.repo)
    local repo_dir = joinpath(M.dpp_base_path, "repos", repo_path)
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
    local target_directories =
        vim.iter({ M.extra_args.directories.base, vim.fn.expand("~/dotfiles/home/.config/nvim") }):join(",")
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

local function make_state()
    M.dpp.make_state(
        M.dpp_base_path,
        joinpath(M.extra_args.directories.base, "dpp", "config.ts"),
        M.nvim_appname,
        M.extra_args
    )
    vim.api.nvim_create_autocmd("User", {
        pattern = "Dpp:makeStatePost",
        group = M.rc_autocmds,
        callback = function()
            M.dpp.load_state(M.dpp_base_path)
            auto_install_plugins(M.dpp)
        end,
        once = true,
        nested = true,
    })
end

---@return nil
local function dpp_setup()
    local is_state_stale_or_missing = M.dpp.load_state(M.dpp_base_path) --[[@as boolean]]
    if is_state_stale_or_missing then
        vim.fn["denops#server#wait_async"](function()
            make_state()
        end)
    else
        auto_install_plugins(M.dpp)
    end
    vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = gather_check_files(),
        group = M.rc_autocmds,
        callback = function()
            vim.notify("dpp check_files() is run", vim.log.levels.INFO)
            M.dpp.check_files(M.nvim_appname)
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

local function get_dpp_base_path()
    if M.nvim_appname == "nvim" then
        return joinpath(vim.env.XDG_CACHE_HOME, "dpp")
    else
        return joinpath(vim.env.XDG_CACHE_HOME, M.nvim_appname .. "_dpp")
    end
end

---init.luaで呼び出すdpp.vimの初期設定
---NVIM_APPNAMEを使ってプロファイルとして分離してみる
---NVIM_APPNAMEが設定されていない場合は、デフォルトの`nvim`になる
function M.setup()
    M.nvim_appname = vim.env.NVIM_APPNAME or "nvim"
    M.dpp_base_path = get_dpp_base_path()
    M.rc_autocmds = vim.api.nvim_create_augroup("RcAutocmds", { clear = true })

    ---@param dir string?
    ---@return string
    local base_dir = function(dir)
        dir = dir or nil
        return joinpath(vim.env.XDG_CONFIG_HOME, M.nvim_appname, dir)
    end

    ---@type ExtraArgs
    M.extra_args = {
        neovide = vim.g.neovide --[[@as boolean]] or false,
        directories = {
            base = base_dir(),
            toml = base_dir("toml"),
            rc = base_dir("rc"),
        },
    }

    M.hooks_dir = joinpath(M.extra_args.directories.base, "hooks")
    M.snippet_dir = joinpath(M.extra_args.directories.base, "snippets")
    vim.env.BASE_DIR = M.extra_args.directories.base
    vim.env.HOOKS_DIR = M.hooks_dir

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
    M.dpp = require("dpp")
    dpp_setup()
end

return M
