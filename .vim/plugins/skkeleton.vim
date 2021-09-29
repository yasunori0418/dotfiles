" Toggle skkeleton
" imap <C-j> <Plug>(skkeleton-toggle)
" cmap <C-j> <Plug>(skkeleton-toggle)

" Disable skkeleton
" imap x <Plug>(skkeleton-disable)
" cmap x <Plug>(skkeleton-disable)

function! s:skkeleton_init() abort
    " Load merged dictionary.
    call skkeleton#config({
        \ 'eggLikeNewline': v:true,
        \ 'globalJisyo': expand('$HOME/.skk/dictionary/SKK-JISYO.merge'),
        \ 'userJisyo': expand('$HOME/.skk/skkeleton/skkeleton')
        \ })
    
    " L2X keymaping.
    call skkeleton#register_kanatable('rom', {
        \ 'jj': 'escape',
        \ 'la': ['ぁ', ''],
        \ 'li': ['ぃ', ''],
        \ 'lu': ['ぅ', ''],
        \ 'le': ['ぇ', ''],
        \ 'lo': ['ぉ', ''],
        \ 'll': ['っ', 'l'],
        \ 'ltu': ['っ', ''],
        \ 'ltsu': ['っ', ''],
        \ 'lwa': ['ゎ', ''],
        \ 'lwe': ['ゑ', ''],
        \ 'lwi': ['ゐ', ''],
        \ 'lya': ['ゃ', ''],
        \ 'lyo': ['ょ', ''],
        \ 'lyu': ['ゅ', '']
        \ })
endfunction
autocmd User skkeleton-initialize-pre call s:skkeleton_init()
