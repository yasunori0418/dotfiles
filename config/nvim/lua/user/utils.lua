local M = {}


---一度に複数のキーマップを定義する。
---@param keymaps { mode: table|string, lhs: string, rhs: string|function, ops: table|nil }
M.keymaps_set = function(keymaps)
  for _, keymap in pairs(keymaps) do
    vim.keymap.set(keymap.mode, keymap.lhs, keymap.rhs, keymap.opts)
  end
end


return M
