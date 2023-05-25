local M = {}
local config = vim.fn['skkeleton#config']
local register_kanatable = vim.fn['skkeleton#register_kanatable']
local register_keymap = vim.fn['skkeleton#register_keymap']

M.init = function()
  config({
    eggLikeNewline = true,
    globalDictionaries = {
      { [[~/.skk/skk_dict_merged]], [[euc-jp]] },
      { [[~/.skk/SKK-JISYO.emoji]], [[utf-8]] }
    },
    userJisyo = [[~/.skk/skkeleton]],
    completionRankFile = [[~/.skk/rank.json]]
    }
  )

  register_kanatable('rom', {
    ['jj'] = 'escape',
    ['z\\<Space>'] = { [[\u3000]], [[]] },
    ['~'] = { [[～]], [[]] },
    ['z0'] = { [[\u25CB]], [[]] },
    ['('] = { [[（]], [[]] },
    [')'] = { [[）]], [[]] },
    }
  )
end


M.pre = function()
end


M.post = function()
end


return M
