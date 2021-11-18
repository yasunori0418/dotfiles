call ddc#custom#patch_global('sources', ['around', 'file', 'rg', 'neosnippet'])

" ddc source settings.
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
    \ 'nvim-lsp': {
        \ 'mark': 'lsp',
        \ 'forceCompletionPattern': '\.\w*|:\w*|->\w*',
    \ },
    \ 'cmdline': {'mark': 'cmdline'},
    \ 'cmdline-history': {'mark': 'history'},
    \ 'necovim': {'mark': 'necovim'},
    \ 'rg': {
        \ 'mark': 'ripgrep',
        \ 'matchers': ['matcher_head', 'matcher_length'],
        \ 'minAutoCompleteLength': 4,
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

call ddc#custom#patch_filetype('python', 'sources',
    \ ['nvim-lsp', 'neosnippet', 'around', 'rg', 'file'],
    \ )

call ddc#custom#patch_filetype('vim', 'sources',
    \ ['nvim-lsp', 'necovim', 'around', 'neosnippet', 'file', 'rg'],
    \ )


call ddc#custom#patch_global('sourceParams', {
    \ 'around': {
        \ 'maxSize': 500,
    \ },
    \ })

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
inoremap <silent> <CR> pum#visible() ? '\<Cmd>call pum#map#confirm()<CR>' : '\<CR>'
inoremap <silent> <C-e> <Cmd>call pum#map#cancel()<CR>

" }}}



call ddc#enable()
