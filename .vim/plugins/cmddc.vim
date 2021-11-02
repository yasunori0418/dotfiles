nnoremap : <Cmd>call Cmdline_pre()<CR>:

function! Cmdline_pre() abort
    call dein#source('ddc.vim')

    cnoremap <expr> <TAB>
        \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' : 
        \ ddc#map#manual_complete()
    cnoremap <S-Tab>    <Cmd>call pum#map#insert_relative(-1)<CR>
    set wildchar=<C-t>

    " Overwrite sources.
    let s:prev_buffer_config = ddc#custom#get_buffer()
    call ddc#custom#patch_buffer('sources', 
        \ ['cmdline', 'cmdline-history', 'around'])
    call ddc#custom#patch_buffer('keywordPattern', '[0-9a-zA-Z_:#]*')
    call ddc#custom#patch_buffer('sourceOptions', {
        \ 'cmdline': {
        \   'forceCompletionPattern': '\S/\S*'
        \ },
        \ })

    autocmd User DDCmdlineLeave ++once call Cmdline_post()

    " Enable command line completion.
    call ddc#enable_cmdline_completion()
    call ddc#enable()
endfunction

function! Cmdline_post() abort
    " Restore sources.
    call ddc#custom#set_buffer(s:prev_buffer_config)
    cunmap <TAB>
    set wildchar=<TAB>
endfunction
