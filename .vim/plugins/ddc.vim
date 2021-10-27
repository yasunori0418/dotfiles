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
inoremap <silent><expr> <C-l> ddc#map#complete_common_string()

" <TAB>: completion.
inoremap <silent><expr> <TAB>
    \ pumvisible() ? '<C-n>' :
    \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
    \ '<TAB>' : ddc#map#manual_complete()

" <S-TAB>: completion back.
inoremap <expr><S-TAB> pumvisible() ? '<C-p>' : '<C-h>'
" }}}


" Use ddc.
call ddc#enable()
