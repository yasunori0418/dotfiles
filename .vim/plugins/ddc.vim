call ddc#custom#patch_global('sources', ['around', 'file', 'neosnippet', 'skkeleton'])

call ddc#custom#patch_global('sourceOptions', {
    \ '_': {
        \ 'ignoreCase': v:true,
        \ 'matchers': ['matcher_head'],
        \ 'sorters': ['sorter_rank'],
    \ },
    \ 'around': {
        \ 'mark': 'A',
        \ 'matchers': ['matcher_head', 'matcher_length'],
    \ },
    \ 'file': {
        \ 'mark': 'F',
        \ 'isVolatile': v:true,
        \ 'forceCompletionPattern': '\S/\S*',
    \ },
    \ 'neosnippet': {
        \ 'mark': 'ns',
        \ 'dup': v:true,
    \ },
    \ 'skkeleton': {
        \ 'mark': 'SKK',
        \ 'matchers': ['skkeleton'],
        \ 'sorters': [],
        \ 'minAutoCompleteLength': 2,
    \ },
    \ })

call ddc#custom#patch_global('sourceParams', {
    \ 'around': {
        \ 'maxSize': 500,
    \ },
    \ })

" Keymaping{{{

" Use pum.vim
call ddc#custom#patch_global('completionMenu', 'pum.vim')

inoremap <silent><expr> <TAB>
    \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
    \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
    \ '<TAB>' : ddc#manual_complete()
inoremap <S-TAB> <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-n> <Cmd>call pum#map#select_relative(+1)<CR>
inoremap <C-p> <Cmd>call pum#map#select_relative(-1)<CR>
inoremap <CR> <Cmd>call pum#map#confirm()<CR>
inoremap <C-e> <Cmd>call pum#map#cancel()<CR>

" }}}



" Use ddc.
call ddc#enable()
