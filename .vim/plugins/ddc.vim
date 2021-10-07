" <TAB>: completion.
inoremap <silent><expr> <TAB>
\ pumvisible() ? '<C-n>' :
\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
\ '<TAB>' : ddc#map#manual_complete()

" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'

call ddc#custom#patch_global('sources', ['around', 'file', 'neosnippet', 'skkeleton', 'nvim-lsp'])
call ddc#custom#patch_global('sourceOptions', {
    \ '_': {
        \ 'ignoreCase': v:true,
        \ 'matchers': ['matcher_head'],
        \ 'sorters': ['sorter_rank'],
        \ 'converters': ['converter_remove_overlap'],
    \ },
    \ 'around': {
        \ 'mark': 'A',
        \ 'matchers': ['matcher_head', 'matcher_length'],
        \ 'maxSize': 500,
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
    \ 'nvim-lsp': {
        \ 'mark': 'lsp',
        \ 'forceCompletionPattern': '\.\w*|:\w*|->\w*',
    \ },
    \ 'skkeleton': {
        \ 'mark': 'SKK',
        \ 'matchers': ['skkeleton'],
        \ 'sorters': [],
        \ 'minAutoCompleteLength': 2,
    \ },
    \ })



" Use ddc.
call ddc#enable()
