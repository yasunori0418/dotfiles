local M = {}

---初回起動時にプラグインのダウンロードとruntimepathに追加する
---@param repo string user_name/plugin_name
local function init_plugin(repo)
    local repo_dir = M.dein_dir .. "/repos/github.com/" .. repo
    local plugin_name = vim.fn.split(repo, "/")[2]
    if not vim.regex("/" .. plugin_name):match_str(vim.o.runtimepath) then
        if vim.fn.isdirectory(repo_dir) ~= 1 then
            os.execute("git clone https://github.com/" .. repo .. " " .. repo_dir)
        end
        vim.opt.runtimepath:append(repo_dir)
    end
end

---init.luaで呼び出すdein.vimの初期設定
---NVIM_APPNAMEを使ってプロファイルとして分離してみる
---NVIM_APPNAMEが設定されていない場合は、デフォルトの`nvim`になる
function M.setup()
    local nvim_appname = vim.env.NVIM_APPNAME or "nvim"
    local joinpath = vim.fs.joinpath
    M.dein_dir = nil
    if nvim_appname == "nvim" then
        M.dein_dir = joinpath(vim.env.XDG_CACHE_HOME, "dein")
    else
        M.dein_dir = joinpath(vim.env.XDG_CACHE_HOME, nvim_appname .. "_dein")
    end

    vim.g.base_dir = joinpath(vim.env.XDG_CONFIG_HOME, nvim_appname)
    vim.env.BASE_DIR = vim.g.base_dir

    vim.g.rc_dir = joinpath(vim.g.base_dir, "rc")
    vim.g.snippet_dir = joinpath(vim.g.base_dir, "snippets")
    vim.g.toml_dir = joinpath(vim.g.base_dir, "toml")
    vim.g.hooks_dir = joinpath(vim.g.base_dir, "hooks")
    vim.env.HOOKS_DIR = vim.g.hooks_dir

    init_plugin("Shougo/dein.vim")
    init_plugin("tani/vim-artemis")

end

return M
