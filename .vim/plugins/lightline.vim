set noshowmode
let g:lightline = {}

" Colorscheme{{{
let g:lightline.colorscheme = 'iceberg'
" }}}


" Statusline{{{

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
    \ ['lineinfo'],
    \ ['percent'],
    \ ]
" }}}


" Tabline{{{
let g:lightline.tabline = {}
let g:lightline.tabline.left = [
    \ ['tabs'],
    \ ]
let g:lightline.tabline.right = [
    \ ['close'],
    \ ]

let g:lightline.tab = {}
let g:lightline.tab.active = ['tabnum', 'filename', 'modified']
let g:lightline.tab.inactive = ['tabnum', 'filename', 'modified']
" }}}


" Separator{{{
" 
let g:lightline.separator = {}
let g:lightline.separator.left = ''
let g:lightline.separator.right = ''

" subseparator
let g:lightline.subseparator = {}
let g:lightline.subseparator.left = ''
let g:lightline.subseparator.right = ''
" }}}


" Component{{{
let g:lightline.component = {}
let g:lightline.component.mode = '%{lightline#mode()}'
let g:lightline.component.absolutepath = '%F'
let g:lightline.component.relativepath= '%f'
let g:lightline.component.filename = '%t'
let g:lightline.component.modified = '%M'
let g:lightline.component.bufnum = '%n'
let g:lightline.component.paste = '%{&paste?"PASTE":""}'
let g:lightline.component.readonly = '%R'
let g:lightline.component.charvalue = '%b'
let g:lightline.component.charvaluehex = '%B'
let g:lightline.component.fileencoding = '%{&fenc!=#""?&fenc:&enc}'
let g:lightline.component.fileformat = '%{&ff}'
let g:lightline.component.filetype = '%{&ft!=#""?&ft:"no ft"}'
let g:lightline.component.percent = '%3p%%'
let g:lightline.component.percentwin = '%P'
let g:lightline.component.spell = '%{&spell?&spelllang:""}'
let g:lightline.component.lineinfo = '%3l:%-2c'
let g:lightline.component.line = '%l'
let g:lightline.component.column = '%c'
let g:lightline.component.close = '%999X X '
let g:lightline.component.winnr = '%{winnr()}'
" }}}


" Component_function{{{
let g:lightline.component_function = {}
" }}}


" Component_expand{{{
let g:lightline.component_expand = {}
" }}}


" LightlineUpdate_Command{{{
command! -bar LightlineUpdate source ~/dotfiles/.vim/plugins/lightline.vim
    \ call lightline#init()|
    \ call lightline#colorscheme()|
    \ call lightline#update()
" }}}
