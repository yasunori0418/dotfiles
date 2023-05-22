local M = {}
-- local dein = require('dein')
local utils = require('user.utils')


---deinのcheck_updateで使用するGitHubのTokenの読み込みと確認
---$BASE_DIR/github_patを読み込みます。
---@return boolean
M.check_github_token = function()
  local load_token = utils.load_token(vim.g.base_dir .. '/github_pat')
  if load_token.result then
    vim.g.install_github_api_token = load_token.token
    return true
  else
    return false
  end
end


return M
