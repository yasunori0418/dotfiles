local M = {}

local lsp = vim.lsp

---LSPが動くバッファーに対しての設定をするヘルパー
---[参考リンク]:(https://zenn.dev/ryoppippi/articles/8aeedded34c914)
---
---@param on_attach fun(client: any|nil, buffer: number|nil)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd('LspAttach', {
    group = require('user.utils').vimrc_augroup,
    callback = function(args)
      local buffer = nil
      if args.buf ~= nil then
        buffer = args.buf
      end

      local client = nil
      if args.data ~= nil then
        client = vim.lsp.get_client_by_id(args.data.client_id)
      end
      on_attach(client, buffer)
    end,
    desc = 'Execute autocmd on LspAttach',
  })
end

---フォーマット時のtimeout対応
---5000msだけ待ってやる
function M.format()
  lsp.buf.format({ timeout_ms = 5000 })
end

return M
