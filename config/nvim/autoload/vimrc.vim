
function! vimrc#lightline_git_branch() abort
  if gitbranch#name() ==# ''
    return ''
  else
    if &ambiwidth =~# 'single'
      return ' ' . gitbranch#name()
    else
      return '' . gitbranch#name()
    endif
  endif
endfunction

function! vimrc#lightline_custom_mode() abort
  if lightline#mode() ==# 'INSERT' || lightline#mode() ==# 'COMMAND' || lightline#mode() ==# 'REPLACE'
    if get(g:, 'loaded_skkeleton') == 0
      return lightline#mode()
    endif

    if skkeleton#mode() !=# ''
      return lightline#mode() . '-SKK'
    endif

  endif

  return lightline#mode()
endfunction


" skkeleton default settings
function! vimrc#skkeleton_init() abort
  call skkeleton#config({
    \ 'eggLikeNewline': v:true,
    \ 'globalDictionaries': [['~/.skk/skk_dict_merged', 'euc-jp'], ['~/.skk/SKK-JISYO.emoji', 'utf-8']],
    \ 'userJisyo': '~/.skk/skkeleton',
    \ })

  call skkeleton#register_kanatable('rom', {
    \ 'jj': 'escape',
    \ "z\<Space>": ["\u3000", ''],
    \ '~': ['～', ''],
    \ 'z0': ["\u25CB", ''],
    \ '(': ['（', ''],
    \ ')': ['）', ''],
    \ })

  call vimrc#L2X_Keymap()

endfunction

function! vimrc#skkeleton_pre() abort
  " Overwrite sources
  let s:prev_buffer_config = ddc#custom#get_buffer()
  call ddc#custom#patch_buffer('sources', ['skkeleton'])
endfunction

function! vimrc#skkeleton_post() abort
  " Restore sources
  call ddc#custom#set_buffer(s:prev_buffer_config)
endfunction

" skkeleton L2X function.
function! vimrc#L2X_Keymap() abort
  call skkeleton#register_kanatable('rom', vimrc#L2X_table())
  call skkeleton#register_keymap('input', 'x', 'disable')
  call skkeleton#register_keymap('input', 'X', 'zenkaku')
  call skkeleton#register_kanatable('rom', {'<s-x>': 'zenkaku'})
  call skkeleton#register_kanatable('rom', {'<s-l>': ['L', '']}, v:false)
endfunction

function! vimrc#L2X_table() abort

  let s:rom_table = {}
  let s:disable_l_nexts = split('bcdfghjkmnpqrsvxzBCDFGHJKMNPQRSVXZ,./1234567890-+=`~;:[]{}()<>!@#$%^&*_\"', '\zs')
  call add(s:disable_l_nexts, "'")
  call map(s:disable_l_nexts, {_, val -> 'l' . val})

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

function! vimrc#ddc_change_filter(bang_flg, filter_name) abort
  if a:filter_name ==# 'normal'
    call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
        \ 'ignoreCase': v:true,
        \ 'matchers': ['matcher_head', 'matcher_length'],
        \ 'sorters': ['sorter_rank'],
        \ 'converters': ['converter_remove_overlap'],
        \ },
      \ })
  elseif a:filter_name ==# 'fuzzy'
    call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
        \ 'ignoreCase': v:true,
        \ 'matchers': ['matcher_fuzzy'],
        \ 'sorters': ['sorter_fuzzy'],
        \ 'converters': ['converter_fuzzy'],
        \ },
      \ })
  endif
  if a:bang_flg == 1
    echo ddc#custom#get_global()['sourceOptions']['_']
  endif
endfunction

" vim-molder function
function! vimrc#molder_init() abort
  if isdirectory(expand('%:p'))
    call dein#source('vim-molder')
    call molder#init()
    autocmd! vimrc_molder
  endif
endfunction

function! vimrc#molder_change_cwd() abort
  if &filetype ==# 'molder'
    let molder_cwd = substitute(bufname('%'), expand('~'), '~', '')
    let molder_cwd = substitute(molder_cwd, '/$', '', '')
    call chdir(molder_cwd)
    echomsg 'Change current working directory to [' . molder_cwd . ']'
  endif
endfunction
