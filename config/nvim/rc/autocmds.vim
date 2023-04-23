" User settings auto command group. {{{

augroup user_filename_filetype
  autocmd!
  autocmd BufNewFile,BufRead *.blade.*            setlocal filetype=html
  autocmd BufNewFile,BufRead *.uml                setlocal filetype=plantuml
  autocmd BufNewFile,BufRead .textlintrc          setlocal filetype=json
  autocmd BufNewFile,BufRead */i3/config          setlocal filetype=i3config
augroup END

augroup user_nolisted_buffer
  autocmd!
  autocmd FileType gin-*      setlocal nobuflisted
augroup END

augroup user_quickfix_autocmd
  autocmd!
  autocmd QuickFixCmdPost *grep* cwindow
augroup END
" }}}
