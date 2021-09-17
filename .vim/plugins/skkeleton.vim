" Toggle skkeleton
imap <C-j> <Plug>(skkeleton-toggle)
cmap <C-j> <Plug>(skkeleton-toggle)

" Disable skkeleton
" imap <C-x> <Plug>(skkeleton-disable)
" cmap <C-x> <Plug>(skkeleton-disable)

" Load merged dictionary.
call skkeleton#config({
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
