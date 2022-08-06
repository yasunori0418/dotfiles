imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)


" SuperTab like snippets behavior.
" imap <expr><TAB> pum#visible() ? 
"     \ '<Cmd>call pum#map#select_relative(+1)<CR>' : neosnippet#jumpable() ? 
"     \ '\<Plug>(neosnippet_expand_or_jump)' : '\<TAB>'
" smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
"     \ '\<Plug>(neosnippet_expand_or_jump)' : '\<TAB>'

"if has('conceal')
"  set conceallevel=2 concealcursor=niv
"endif
