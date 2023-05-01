local autocmd = vim.api.nvim_create_autocmd
local M = {}

---全体共通設定のaugroup_id
---@return integer
M.vimrc_augroup = vim.api.nvim_create_augroup('vimrc', {clear = false})

---autocmd単発用
---自動でvimrcグループにセットする
---@param events table|string
---@param pattern table|string
---@param callback function|string
M.autocmd_set = function (events, pattern, callback)
  autocmd(events, {
    group = M.vimrc_augroup,
    pattern = pattern,
    callback = callback,
  })
end

---複数のautocmdを定義する
---@param autocmds { events: string|table, pattern: table|string, group: integer, callback: function|string }
M.autocmds_set = function (autocmds)
  for _, item in pairs(autocmds) do
    autocmd(item.events, {
      group = item.group,
      pattern = item.pattern,
      callback = item.callback,
    })
  end
end

---複数のキーマップを定義する。
---@param keymaps { mode: table|string, lhs: string, rhs: string|function, ops: table|nil }
M.keymaps_set = function(keymaps)
  for _, keymap in pairs(keymaps) do
    vim.keymap.set(keymap.mode, keymap.lhs, keymap.rhs, keymap.opts)
  end
end


return M
