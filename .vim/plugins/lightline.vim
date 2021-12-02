set noshowmode
let g:lightline = {}

autocmd User skkeleton-mode-changed redrawstatus

" Colorscheme{{{

let g:lightline.colorscheme = 'nightfox'

" }}}


" Statusline{{{

" active
let g:lightline.active = {}
let g:lightline.active.left = [
    \ ['mode', 'paste', 'skk_mode'], 
    \ ['git_branch', 'filename', 'modified'],
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

if &ambiwidth =~ 'single'

    let g:lightline.separator = {}
    let g:lightline.separator.left = ' '
    let g:lightline.separator.right = ' '

    let g:lightline.subseparator = {}
    let g:lightline.subseparator.left = ' '
    let g:lightline.subseparator.right = ' '

endif

" }}}


" Component_default{{{

let g:lightline.component = {}
let g:lightline.component = {
    \ 'mode': '%{lightline#mode()}',
    \ 'absolutepath': '%F',
    \ 'relativepath': '%f',
    \ 'filename': '%t',
    \ 'modified': '%M',
    \ 'bufnum': '%n',
    \ 'paste': '%{&paste?"PASTE":""}',
    \ 'readonly': '%R',
    \ 'charvalue': '%b',
    \ 'charvaluehex': '%B',
    \ 'fileencoding': '%{&fenc!=#""?&fenc:&enc}',
    \ 'fileformat': '%{&ff}',
    \ 'filetype': '%{&ft!=#""?&ft:"no ft"}',
    \ 'percent': '%3p%%',
    \ 'percentwin': '%P',
    \ 'spell': '%{&spell?&spelllang:""}',
    \ 'lineinfo': '%3l:%-2c',
    \ 'line': '%l',
    \ 'column': '%c',
    \ 'close': '%999X X ',
    \ 'winnr': '%{winnr()}' }

" }}}


" Component{{{

" let g:lightline.component.git_branch = '%{FugitiveStatusline()}'

" }}}


" Component_function{{{

let g:lightline.component_function = {}
let g:lightline.component_function.git_branch = 'g:LightlineFugitive'
let g:lightline.component_function.skk_mode = 'g:LightlineSkkeleton'
let g:lightline.component_function.mode = 'g:LightlineMode'

" }}}


" Component_expand{{{

let g:lightline.component_expand = {}

" }}}


" Component_expand_type{{{

let g:lightline.component_expand_type = {}

" }}}


" LightlineUpdate_Command{{{

command! -bar LightlineUpdate source ~/dotfiles/.vim/plugins/lightline.vim|
    \ call lightline#init()|
    \ call lightline#colorscheme()|
    \ call lightline#update()

" }}}


" Branch name{{{

function! g:LightlineFugitive() abort

    if &ft !~? 'help\|denite\|defx\|tagbar' && exists('*FugitiveHead') && FugitiveStatusline() != ''
        return '' . FugitiveHead()
    else
        return ''
    endif
endfunction

" }}}


" Skkeleton mode{{{

function! g:LightlineSkkeleton() abort

    if get(g:, 'loaded_skkeleton') == 0
        return ''
    endif

    if lightline#mode() == 'INSERT' || lightline#mode() == 'COMMAND'
        if skkeleton#mode() == 'hira'
            return 'あ﫦'
        elseif skkeleton#mode() == 'kata'
            return 'ア﫦'
        else
            return 'Aa﫦'
        endif
    else
        return ''
    endif

endfunction

" }}}


" Custom Lightline mode{{{

function! g:LightlineMode() abort

    if lightline#mode() == 'INSERT' || lightline#mode() == 'COMMAND'
        if get(g:, 'loaded_skkeleton') == 0
            return lightline#mode()
        endif

        if skkeleton#mode() != ''
            return lightline#mode() .. '-SKK'
        else
           return lightline#mode()
        endif
    else
        return lightline#mode()
    endif

endfunction

" }}}
