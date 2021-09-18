set noshowmode
let g:lightline = {}
let g:lightline.component = {}
let g:lightline.component_function = {}
let g:lightline.component_expand = {}

" ================================================================
" colorscheme
let g:lightline.colorscheme = 'iceberg'
" ================================================================


" ================================================================
" active
let g:lightline.active = {}
let g:lightline.active.left = [
    \ ['mode', 'paste'], 
    \ ['readonly', 'filename', 'modifide'],
    \ ]
let g:lightline.active.right = [
    \ ['lineinfo'],
    \ ['percent'],
    \ ['fileformat', 'fileencoding', 'filetype'],
    \ ]

" inactive
let g:lightline.inactive = {}
let g:lightline.inactive.left = [
    \ ['filename']
    \ ]
let g:lightline.inactive.right = [
    \ ['percent'],
    \ ['fileformat', 'fileencoding', 'filetype'],
    \ ]
" ================================================================


" ================================================================
" tabline
let g:lightline.tabline = {}
let g:lightline.tabline.left = [
    \ ['tabs'],
    \ ]
let g:lightline.tabline.right = [
    \ ['close'],
    \ ]
" ================================================================


" ================================================================
" separator 
let g:lightline.separator = {}
let g:lightline.separator.left = ''
let g:lightline.separator.right = ''

" subseparator
let g:lightline.subseparator = {}
let g:lightline.subseparator.left = ''
let g:lightline.subseparator.right = ''
" ================================================================


" ================================================================
command! -bar LightlineUpdate source ~/dotfiles/.vim/plugins/lightline.vim
    \ call lightline#init()|
    \ call lightline#colorscheme()|
    \ call lightline#update()
