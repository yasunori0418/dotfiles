local M = {}

---全体のautocmd設定共通のaugroup_id
---@return integer
M.vimrc_augroup = vim.api.nvim_create_augroup('vimrc', {clear = false})

---複数のautocmdを定義する
---@param autocmds { events: string|table, group: integer, callback: function|string }
M.autocmds_set = function (autocmds)
  for _, autocmd in pairs(autocmds) do
    vim.api.nvim_create_autocmd(
      autocmd.events, {
        group = autocmd.group,
        pattern = autocmd.pattern,
        callback = autocmd.callback,
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
