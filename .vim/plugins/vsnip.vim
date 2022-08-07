imap <expr> <C-k> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-k>'
smap <expr> <C-k> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-k>'

" Jump forward or backward
imap <expr> <C-n> vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<C-n>'
smap <expr> <C-n> vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<C-n>'
imap <expr> <C-p> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-p>'
smap <expr> <C-p> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-p>'

let g:vsnip_snippet_dirs = [
  \ expand('~/.vsnip/friendly-snippets/snippets/'),
  \ ]

augroup user_vsnip_autocmd
  autocmd!
  autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)
augroup END
