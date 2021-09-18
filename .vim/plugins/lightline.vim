set noshowmode
let g:lightline = {}
let g:lightline.active = {}
let g:lightline.inactive = {}
let g:lightline.tabline = {}
let g:lightline.separator = {}
let g:lightline.subseparator = {}
let g:lightline.component = {}
let g:lightline.component_function = {}
let g:lightline.component_expand = {}

" colorscheme
let g:lightline.colorscheme = 'iceberg'

" active
let g:lightline.active.left = [
    \ ['mode', 'paste'], 
    \ ['readonly', 'filename', 'modifide']
    \ ]
let g:lightline.active.right = [
    \ ['lineinfo'],
    \ ['percent'],
    \ ['fileformat', 'fileencoding', 'filetype']
    \ ]

" inactive
let g:lightline.inactive.left = [
    \ ['filename']
    \ ]
let g:lightline.inactive.right = [
    \ ['percent'],
    \ ['fileformat', 'fileencoding', 'filetype']
    \ ]

" tabline
let g:lightline.tabline.left = [
    \ ['tabs']
    \ ]
let g:lightline.tabline.right = [
    \ ['close']
    \ ]

command! -bar LightlineUpdate call lightline#init()|
    \ call lightline#colorscheme()|
    \ call lightline#update()
