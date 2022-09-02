set noshowmode
let g:lightline = {}

" Colorscheme{{{

let g:lightline.colorscheme = 'nordfox'

" }}}

" Statusline{{{

" active
let g:lightline.active = {}
let g:lightline.active.left = [
  \ ['mode', 'paste', 'skk_mode'], 
  \ ['git_branch', 'relativepath', 'modified'],
  \ ]
let g:lightline.active.right = [
  \ ['percent', 'lsp_errors', 'lsp_warnings', 'lsp_ok'],
  \ ['lineinfo'],
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

  let g:lightline.separator = {
    \ 'left': '',
    \ 'right': '',
    \ }

  let g:lightline.subseparator = {
    \ 'left': '',
    \ 'right': '',
    \ }

endif

" }}}

" Component{{{

" let g:lightline.component.git_branch = '%{FugitiveStatusline()}'

" }}}

" Component_function{{{

let g:lightline.component_function = {
  \ 'git_branch': 'g:LightlineGitBranch',
  \ 'mode': 'g:LightlineMode',
  \ 'skk_mode': 'lightline_skk#mode',
  \ }

" }}}

" Component_expand{{{

let g:lightline.component_expand = {
  \ 'lsp_ok': 'lightline_lsp#ok',
  \ 'lsp_errors': 'lightline_lsp#errors',
  \ 'lsp_warnings': 'lightline_lsp#warnings',
  \ }

" }}}

" Component_expand_type{{{

let g:lightline.component_expand_type = {
  \ 'lsp_ok': 'middle',
  \ 'lsp_errors': 'error',
  \ 'lsp_warnings': 'warning',
  \ }

" }}}

" LightlineUpdate_Command{{{

command! -bar LightlineUpdate source ~/dotfiles/.vim/plugins/lightline.vim|
  \ call lightline#init()|
  \ call lightline#colorscheme()|
  \ call lightline#update()

" }}}

" Custom Lightline mode{{{

function! g:LightlineMode() abort

  if lightline#mode() == 'INSERT' || lightline#mode() == 'COMMAND' || lightline#mode() == 'REPLACE'
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

" git branch {{{

function! g:LightlineGitBranch() abort
  if gitbranch#name() == ''
    return ''
  else
    return  ' ' .. gitbranch#name()
  endif
endfunction

" }}}
