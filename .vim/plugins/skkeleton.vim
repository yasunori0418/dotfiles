function! s:skkeleton_init() abort
  call skkeleton#config({
    \ 'eggLikeNewline': v:true,
    \ 'userJisyo': '~/.skk/skkeleton/skkeleton'
    \ })

  call skkeleton#register_kanatable('rom', {
    \ 'jj': 'escape',
    \ "z\<Space>": ["\u3000", ''],
    \ '~': ['～', ''],
    \ 'z0': ["\u25CB", ''],
    \ })

  call s:L2X_Keymap()

endfunction


function! s:L2X_Keymap() abort
  call skkeleton#register_kanatable('rom', s:L2X_table())

  call skkeleton#register_keymap('input', "x", 'disable')
  call skkeleton#register_keymap('input', "X", 'zenkaku')
endfunction


function! s:L2X_table() abort

  let s:rom_table = {}

  let s:disable_l_nexts = split('bcdfghjkmnpqrsvxzBCDFGHJKMNPQRSVXZ,./1234567890-+=`~;:[]{}()<>!@#$%^&*_\"', '\zs')
  call add(s:disable_l_nexts, "'")
  call map(s:disable_l_nexts, {_, val -> 'l' .. val})

  for s:disable_l_next in s:disable_l_nexts
    let s:rom_table[s:disable_l_next] = ['', '']
  endfor

  let s:enable_l_converts = {
    \ 'la': ['ぁ', ''],
    \ 'li': ['ぃ', ''],
    \ 'lu': ['ぅ', ''],
    \ 'le': ['ぇ', ''],
    \ 'lo': ['ぉ', ''],
    \ 'll': ['っ', 'l'],
    \ 'ltu': ['っ', ''],
    \ 'ltsu': ['っ', ''],
    \ 'lwa': ['ゎ', ''],
    \ 'lwe': ['ゑ', ''],
    \ 'lwi': ['ゐ', ''],
    \ 'lya': ['ゃ', ''],
    \ 'lyo': ['ょ', ''],
    \ 'lyu': ['ゅ', ''],
    \ }

  for s:item in items(s:enable_l_converts)
    let s:rom_table[s:item[0]] = s:item[1]
  endfor

  let s:disable_x_converts = {
    \ 'xa': ['', ''],
    \ 'xi': ['', ''],
    \ 'xu': ['', ''],
    \ 'xe': ['', ''],
    \ 'xo': ['', ''],
    \ 'xx': ['', ''],
    \ 'xtu': ['', ''],
    \ 'xtsu': ['', ''],
    \ 'xwa': ['', ''],
    \ 'xwe': ['', ''],
    \ 'xwi': ['', ''],
    \ 'xya': ['', ''],
    \ 'xyo': ['', ''],
    \ 'xyu': ['', ''],
    \ }

  for s:item in items(s:disable_x_converts)
    let s:rom_table[s:item[0]] = s:item[1]
  endfor

  return s:rom_table

endfunction

function! s:skkeleton_pre() abort
  " Overwrite sources
  let s:prev_buffer_config = ddc#custom#get_buffer()
  call ddc#custom#patch_buffer('sources', ['skkeleton'])
endfunction

function! s:skkeleton_post() abort
  " Restore sources
  call ddc#custom#set_buffer(s:prev_buffer_config)
endfunction

autocmd User skkeleton-initialize-pre call s:skkeleton_init()
autocmd User skkeleton-enable-pre call s:skkeleton_pre()
autocmd User skkeleton-disable-pre call s:skkeleton_post()
