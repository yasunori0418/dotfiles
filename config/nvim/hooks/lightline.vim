" hook_source {{{
set noshowmode
set showtabline=2
set laststatus=3
let g:lightline = {}
let g:lightline.colorscheme = 'nordfox'
" active
let g:lightline.active = {}
let g:lightline.active.left = [
  \ ['mode', 'paste', 'skk_mode'], 
  \ ['relativepath', 'modified'],
  \ ]
let g:lightline.active.right = [
  \ ['percent', 'lineinfo'],
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

let g:lightline.tabline = {}
let g:lightline.tabline.left = [
  \ ['tabs'],
  \ ]
let g:lightline.tabline.right = [
  \ ['git_branch'],
  \ ]

let g:lightline.tab = {}
let g:lightline.tab.active = ['tabnum', 'filename', 'modified']
let g:lightline.tab.inactive = ['tabnum', 'filename']

let g:lightline.separator = {
  \ 'left': '',
  \ 'right': '',
  \ }
let g:lightline.subseparator = {
  \ 'left': '',
  \ 'right': ' ',
  \ }

let g:lightline.component_function = {
  \ 'git_branch': 'vimrc#lightline_git_branch',
  \ 'mode': 'vimrc#lightline_custom_mode',
  \ 'skk_mode': 'lightline_skk#mode',
  \ }

let g:lightline.component_expand = {
  \ 'lsp_ok': 'lightline_lsp#ok',
  \ 'lsp_errors': 'lightline_lsp#errors',
  \ 'lsp_warnings': 'lightline_lsp#warnings',
  \ }

let g:lightline.component_expand_type = {
  \ 'lsp_ok': 'middle',
  \ 'lsp_errors': 'error',
  \ 'lsp_warnings': 'warning',
  \ }

command! -bar LightlineUpdate call lightline#init()| call lightline#colorscheme()| call lightline#update()

" }}}
