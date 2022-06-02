" US keyboard layout.
nnoremap ; <Cmd>call Cmdline_pre(':')<CR>:
xnoremap ; <Cmd>call Cmdline_pre(':')<CR>:

nnoremap / <Cmd>call Cmdline_pre('/')<CR>/
nnoremap ? <Cmd>call Cmdline_pre('?')<CR>?

function! Cmdline_pre(mode) abort
  call dein#source('ddc.vim')

  cnoremap <expr> <TAB>
    \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' : 
    \ ddc#map#manual_complete()
  cnoremap <S-Tab>    <Cmd>call pum#map#insert_relative(-1)<CR>

  " Note: It disables default command line completion!
  set wildchar=<C-t>

  " Overwrite sources.
  if !exists('b:prev_buffer_config')
    let b:prev_buffer_config = ddc#custom#get_buffer()
  endif
  if a:mode == ':'
    call ddc#custom#patch_buffer('cmdlineSources', 
      \ ['cmdline', 'cmdline-history', 'file', 'around'])
    call ddc#custom#patch_buffer('keywordPattern', '[0-9a-zA-Z_:#]*')
  else
    call ddc#custom#patch_buffer('cmdlineSources',
      \ ['around', 'line'])
  endif

  autocmd User DDCmdlineLeave ++once call Cmdline_post()
  autocmd InsertEnter <buffer> ++once call Cmdline_post()

  " Enable command line completion.
  call ddc#enable_cmdline_completion()
  call ddc#enable()
endfunction

function! Cmdline_post() abort
  " Restore sources.
  if exists('b:prev_buffer_config')
    call ddc#custom#set_buffer(b:prev_buffer_config)
    unlet b:prev_buffer_config
  else
    call ddc#custom#set_buffer({})
  endif

  set wildchar=<TAB>
endfunction
