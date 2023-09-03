local M = {}
local dein = require('dein')
local utils = require('user.utils')


---deinのcheck_updateで使用するGitHubのTokenの読み込みと確認
---$BASE_DIR/github_patを読み込みます。
---@return boolean
function M.check_github_token()
  local load_token = utils.load_token(vim.g.base_dir .. '/github_pat')
  if load_token.result then
    vim.g.install_github_api_token = load_token.token
    return true
  else
    return false
  end
end


---deinで使われていないプラグインをアンインストールする。
---削除を確認する。
function M.check_uninstall()
  local remove_plugins = dein.check_clean()
  if #remove_plugins > 0 then
    for _, remove_plugin in pairs(remove_plugins) do
      print(remove_plugin)
    end
    local choice = vim.fn.confirm('Would you like to remove those plugins?', "&Yes\n&no", 1)
    vim.print(choice)
    if choice == 1 then
      vim.fn.map(
        remove_plugins,
        function(_, remove_plugin)
          vim.fn.delete(remove_plugin, 'rf')
        end
      )
      dein.recache_runtimepath()
      print('Remove Plugins ...done!')
    else
      print('Remove Plugins ...abort!')
    end
  else
    print('There are no plugins to remove.')
  end
end


return M
