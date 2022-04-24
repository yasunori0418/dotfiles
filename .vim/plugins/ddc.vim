call ddc#custom#patch_global('sources', ['around', 'file', 'rg'])

" ddc source settings. {{{
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
        \ 'minAutoCompleteLength': 1000,
        \ 'forceCompletionPattern': '\S/\S*',
        \ },
    \ 'neosnippet': {
        \ 'mark': 'ns',
        \ 'dup': v:true,
        \ },
    \ 'vim-lsp': {
        \ 'mark': 'lsp',
        \ 'matchers': ['matcher_head'],
        \ 'forceCompletionPattern': '\.\w*|:\w*|->\w*',
        \ },
    \ 'cmdline': {
        \ 'mark': 'cmdline',
        \ 'forceCompletionPattern': '\S/\S*',
        \ },
    \ 'cmdline-history': {
        \ 'mark': 'history',
        \ 'sorters': [],
        \ },
    \ 'necovim': {'mark': 'necovim'},
    \ 'rg': {
        \ 'mark': 'ripgrep',
        \ 'matchers': ['matcher_head', 'matcher_length'],
        \ 'minAutoCompleteLength': 4,
        \ },
    \ 'zsh': {
        \ 'mark': 'zsh',
        \ 'isVolatile': v:true,
        \ 'forceCompletionPattern': '\S/\S*',
        \ },
    \ 'shell-history': {
        \ 'mark': 'shell',
        \ 'minKeywordLength': 4,
        \ 'maxKeywordLength': 50,
        \ },
    \ })

call ddc#custom#patch_global('sourceOptions', {
    \ 'skkeleton': {
        \ 'mark': 'SKK',
        \ 'matchers': ['skkeleton'],
        \ 'sorters': [],
        \ 'minAutoCompleteLength': 2,
    \ },
    \ })

" }}}

call ddc#custom#patch_global('sourceParams', {
    \ 'around': {
        \ 'maxSize': 500,
        \ },
    \ })

" filetype settings of ddc-sources. {{{

call ddc#custom#patch_filetype('python', 'sources',
    \ ['vim-lsp', 'neosnippet', 'around', 'file', 'rg'],
    \ )

call ddc#custom#patch_filetype(['toml', 'vim'], 'sources',
    \ ['necovim', 'around', 'neosnippet', 'file', 'rg'],
    \ )

" call ddc#custom#patch_filetype(['deol', 'zsh'], 'sources', 
"     \ ['zsh', 'shell-history', 'around'],
"     \ )

" }}}

" Keymaping{{{

" Use pum.vim
call ddc#custom#patch_global('autoCompleteEvents', [
      \ 'InsertEnter', 'TextChangedI', 'TextChangedP',
      \ 'CmdlineEnter', 'CmdlineChanged',
      \ ])

call ddc#custom#patch_global('completionMenu', 'pum.vim')

inoremap <silent><expr> <TAB>
    \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
    \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
    \ '<TAB>' : ddc#manual_complete()
inoremap <silent> <S-TAB> <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <silent> <C-n> <Cmd>call pum#map#select_relative(+1)<CR>
inoremap <silent> <C-p> <Cmd>call pum#map#select_relative(-1)<CR>
inoremap <silent> <C-y> <Cmd>call pum#map#confirm()<CR>
inoremap <silent> <C-e> <Cmd>call pum#map#cancel()<CR>
inoremap <silent><expr> <C-l> ddc#map#extend()

" }}}


call ddc#enable()
