autocmd User skkeleton-mode-changed redrawstatus

function! s:skkeleton_init() abort
    " Load merged dictionary.
    call skkeleton#config({
        \ 'eggLikeNewline': v:true,
        \ 'userJisyo': '~/.skk/skkeleton/skkeleton'
        \ })

    call skkeleton#register_kanatable('rom', {
        \ 'jj': 'escape',
        \ })
endfunction

autocmd User skkeleton-initialize-pre call s:skkeleton_init()

function! s:skkeleton_pre() abort
    " Overwrite sources
    let s:prev_buffer_config = ddc#custom#get_buffer()
    call ddc#custom#patch_buffer('sources', ['skkeleton'])
endfunction

autocmd User skkeleton-enable-pre call s:skkeleton_pre()


function! s:skkeleton_post() abort
    " Restore sources
    call ddc#custom#set_buffer(s:prev_buffer_config)
endfunction

autocmd User skkeleton-disable-pre call s:skkeleton_post()
