local utils = require('user.utils')

local M = {}

---初回起動時にプラグインのダウンロードとruntimepathに追加する
---@param dein_dir string deinのキャッシュディレクトリ
---@param repo string user_name/plugin_name
local init_plugin = function(dein_dir, repo)
  local repo_dir = dein_dir .. "/repos/github.com/" .. repo
  local plugin_name = vim.fn.split(repo, "/")[2]
  if not vim.regex("/" .. plugin_name):match_str(vim.o.runtimepath) then
    if vim.fn.isdirectory(repo_dir) ~= 1 then
      os.execute("git clone https://github.com/" .. repo .. " " .. repo_dir)
    end
    vim.opt.runtimepath:append(repo_dir)
  end
end

---dein.vimの読み込み処理
---@param dein_dir string
local dein_setup = function(dein_dir)
  local dein = require("dein")
  local inline_vimrcs = utils.gather_files(vim.g.base_dir, "rc")
  local toml_files = utils.gather_files(vim.g.base_dir, "toml")

  utils.remove_file_from_gather_files(inline_vimrcs, 'neovide.lua')

  dein.setup({
    install_progress_type = "none",
    enable_notification = true,
    auto_recache = true,
    lazy_rplugins = true,
    install_check_diff = true,
    -- Strict check updated plugins yesterday
    install_check_remote_threshold = 24 * 60 * 60,
    inline_vimrcs = inline_vimrcs:totable(),
  })

  if dein.load_state(dein_dir) == 1 then
    dein.begin(dein_dir)
    toml_files:each(function(toml_file)
      dein.load_toml(
        toml_file, {
          lazy = vim.regex([[dein.toml]]):match_str(toml_file) == nil
        })
    end)
    dein.end_()
    dein.save_state()
  end

  if dein.check_install() then
    dein.install()
  end
end

---init.luaで呼び出すdein.vimの初期設定
---NVIM_APPNAMEを使ってプロファイルとして分離してみる
---NVIM_APPNAMEが設定されていない場合は、デフォルトの`nvim`になる
M.setup = function()
  local nvim_appname = vim.env.NVIM_APPNAME or "nvim"
  local dein_dir = nil
  if nvim_appname == "nvim" then
    dein_dir = vim.env.XDG_CACHE_HOME .. "/dein"
  else
    dein_dir = vim.env.XDG_CACHE_HOME .. "/" .. nvim_appname .. "_dein"
  end

  vim.g.base_dir = vim.env.XDG_CONFIG_HOME .. "/" .. nvim_appname
  vim.env.BASE_DIR = vim.g.base_dir

  init_plugin(dein_dir, "Shougo/dein.vim")
  init_plugin(dein_dir, "tani/vim-artemis")

  dein_setup(dein_dir)
end

return M
