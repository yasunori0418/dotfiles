local M = {}
local config = vim.fn['skkeleton#config']
local register_kanatable = vim.fn['skkeleton#register_kanatable']
-- local register_keymap = vim.fn['skkeleton#register_keymap']
local ddc_custom_get_buffer = vim.fn['ddc#custom#get_buffer']
local ddc_custom_set_buffer = vim.fn['ddc#custom#set_buffer']
local ddc_custom_patch_buffer = vim.fn['ddc#custom#patch_buffer']

-- local L2X = function()
-- end


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
    ['z '] = { '　', '' },
    ['~'] = { '～', '' },
    ['z0'] = { '○', '' },
    ['('] = { '（', '' },
    [')'] = { '）', '' },
    }
  )
end


M.pre = function()
  vim.b.prev_buffer_config = ddc_custom_get_buffer()
  ddc_custom_patch_buffer('sources', { 'skkeleton' })
end


M.post = function()
  ddc_custom_set_buffer(vim.b.prev_buffer_config)
end


return M
