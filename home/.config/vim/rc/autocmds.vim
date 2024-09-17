augroup filetypeIndent
  autocmd!
  autocmd FileType html setlocal tabstop=2 softtabstop=2 shiftwidth=2
  autocmd FileType css setlocal tabstop=2 softtabstop=2 shiftwidth=2
  autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType php setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType make setlocal tabstop=4 softtabstop=0 shiftwidth=0 noexpandtab
  autocmd FileType sshconfig setlocal tabstop=4 softtabstop=0 shiftwidth=0 noexpandtab
  autocmd FileType gitconfig setlocal tabstop=4 softtabstop=0 shiftwidth=0 noexpandtab
augroup END

augroup MyVimrcAutocmds
  autocmd!
  autocmd QuickFixCmdPost *grep* cwindow
  autocmd WinEnter * checktime %
augroup END
