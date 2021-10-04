" <TAB>: completion.
inoremap <silent><expr> <TAB>
\ pumvisible() ? '<C-n>' :
\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
\ '<TAB>' : ddc#map#manual_complete()

" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'

call ddc#custom#patch_global('sources', ['around', 'file', 'neosnippet', 'skkeleton'])
call ddc#custom#patch_global('sourceOptions', {
    \ '_': {
        \ 'matchers': ['matcher_head'],
        \ 'sorters': ['sorter_rank'],
    \ },
    \ 'around': {
        \ 'mark': 'A',
        \ 'matchers': ['matcher_head', 'matcher_length'],
    \ },
    \ 'neosnippet': {
        \ 'mark': 'ns',
        \ 'dup': v:true,
    \ },
    \ 'file': {
        \ 'mark': 'F',
        \ 'isVolatile': v:true,
        \ 'forceCompletionPattern': '\S/\S*',
    \ },
    \ 'skkeleton': {
        \ 'mark': 'SKK',
        \ 'matchers': ['skkeleton'],
        \ 'sorters': [],
    \ },
    \ })



" Use ddc.
call ddc#enable()
