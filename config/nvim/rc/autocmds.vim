" User settings auto command group. {{{

augroup user_filename_filetype
  autocmd!
  autocmd BufNewFile,BufRead *.blade.*            setlocal filetype=html
  autocmd BufNewFile,BufRead *.uml                setlocal filetype=plantuml
  autocmd BufNewFile,BufRead .textlintrc          setlocal filetype=json
  autocmd BufNewFile,BufRead */i3/config          setlocal filetype=i3config
augroup END

augroup user_filetype_indent
  autocmd!
  autocmd FileType html       setlocal tabstop=2 softtabstop=2 shiftwidth=2
  autocmd FileType css        setlocal tabstop=2 softtabstop=2 shiftwidth=2
  autocmd FileType python     setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType php        setlocal tabstop=4 softtabstop=4 shiftwidth=4 noautoindent
  autocmd FileType xml        setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType markdown   setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType dockerfile setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType make       setlocal tabstop=4 softtabstop=0 shiftwidth=0 noexpandtab
augroup END

augroup user_nolisted_buffer
  autocmd!
  autocmd FileType gin-*      setlocal nobuflisted
augroup END

augroup user_quickfix_autocmd
  autocmd!
  autocmd QuickFixCmdPost *grep* cwindow
augroup END

augroup user_other_settings
  autocmd!
  autocmd FileType help setlocal conceallevel=0
augroup END

" }}}
