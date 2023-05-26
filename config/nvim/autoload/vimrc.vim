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
