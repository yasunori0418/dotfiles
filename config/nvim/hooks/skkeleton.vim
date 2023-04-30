" hook_add {{{
imap <C-j> <Plug>(skkeleton-toggle)
cmap <C-j> <Plug>(skkeleton-toggle)
" }}}

" hook_source {{{
augroup skkeleton_autocmds
  autocmd!
  autocmd User skkeleton-initialize-pre call vimrc#skkeleton_init()
  autocmd User skkeleton-enable-pre call vimrc#skkeleton_pre()
  autocmd User skkeleton-disable-pre call vimrc#skkeleton_post()
  autocmd InsertLeave * mode
augroup END
" }}}
