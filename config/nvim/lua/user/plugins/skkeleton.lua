local M = {}
local config = vim.fn['skkeleton#config']
local register_kanatable = vim.fn['skkeleton#register_kanatable']
local register_keymap = vim.fn['skkeleton#register_keymap']
local ddc_custom_get_buffer = vim.fn['ddc#custom#get_buffer']
local ddc_custom_set_buffer = vim.fn['ddc#custom#set_buffer']
local ddc_custom_patch_buffer = vim.fn['ddc#custom#patch_buffer']

local l2x_rom = function()
  local rom = {}
  local disable_l_nexts = vim.fn.split(
    [=[bcdfghjkmnpqrsvxzBCDFGHJKMNPQRSVXZ,./1234567890-+=`~;:[]{}()<>!@#$%^&*_\"']=],
    [[\zs]]
  )

  vim.fn.map(disable_l_nexts, function(_, value)
      rom['l' .. value] = { '', '' }
    end
  )

  local converts = {
    la = { 'ぁ', '' },
    li = { 'ぃ', '' },
    lu = { 'ぅ', '' },
    le = { 'ぇ', '' },
    lo = { 'ぉ', '' },
    ll = { 'っ', 'l' },
    ltu = { 'っ', '' },
    ltsu = { 'っ', '' },
    lwa = { 'ゎ', '' },
    lwe = { 'ゑ', '' },
    lwi = { 'ゐ', '' },
    lya = { 'ゃ', '' },
    lyo = { 'ょ', '' },
    lyu = { 'ゅ', '' },
    xa = { '', '' },
    xi = { '', '' },
    xu = { '', '' },
    xe = { '', '' },
    xo = { '', '' },
    xx = { '', '' },
    xtu = { '', '' },
    xtsu = { '', '' },
    xwa = { '', '' },
    xwe = { '', '' },
    xwi = { '', '' },
    xya = { '', '' },
    xyo = { '', '' },
    xyu = { '', '' },
  }

  vim.fn.map(converts, function(key, value)
      rom[key] = value
    end
  )

  return rom
end


local l2x_maps = function()
  register_kanatable('rom',l2x_rom())
  register_keymap('input', 'x', 'disable')
  register_keymap('input', 'X', 'zenkaku')
  register_kanatable('rom', {
    ['<s-x>'] = 'zenkaku'
  })
  register_kanatable('rom', {
    ['<s-l>'] =  { 'L', '' }
    }, true
  )
end


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
  l2x_maps()
end


M.pre = function()
  vim.b.prev_buffer_config = ddc_custom_get_buffer()
  ddc_custom_patch_buffer('sources', { 'skkeleton' })
end


M.post = function()
  ddc_custom_set_buffer(vim.b.prev_buffer_config)
  vim.b.prev_buffer_config = {}
end


return M
