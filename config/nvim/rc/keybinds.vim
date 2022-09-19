" keybinds
" Nop keys {{{
" Disable s for vim-sandwich
nnoremap s <Nop>
xnoremap s <Nop>
nnoremap S <Nop>
xnoremap S <Nop>

" Invalid because it does not move with t and T.
nnoremap t <Nop>
xnoremap t <Nop>
nnoremap T <Nop>
xnoremap T <Nop>

nnoremap m <Nop>

nnoremap <Space> <Nop>
xnoremap <Space> <Nop>

" kill arrow key move
noremap <Left>   <Nop>
noremap <Down>   <Nop>
noremap <Up>     <Nop>
noremap <Right>  <Nop>
noremap! <Left>   <Nop>
noremap! <Down>   <Nop>
noremap! <Up>     <Nop>
noremap! <Right>  <Nop>
" }}}

" Window control keybind {{{
" overwrites window command of 'CTRL-W'.
" Use prefix [Window].
nnoremap <C-W> <Nop>
nnoremap [Window] <Nop>
nmap <Space>w [Window]

" Commands of move between window.
nnoremap [Window]h <C-W>h
nnoremap [Window]j <C-W>j
nnoremap [Window]k <C-W>k
nnoremap [Window]l <C-W>l

" Commands of move window.
nnoremap [Window]H <C-W>H
nnoremap [Window]J <C-W>J
nnoremap [Window]K <C-W>K
nnoremap [Window]L <C-W>L

" Tab page controls.
nnoremap [Window]th <C-W>gT
nnoremap [Window]tl <C-W>gt
nnoremap [Window]tt <C-W>g<Tab>
nnoremap [Window]tT <C-W>T
nnoremap [Window]tn <Cmd>tabnew<CR>
nnoremap [Window]tN <Cmd>-tabnew<CR>

" Commands of close window.
nnoremap [Window]q <C-W>q
nnoremap [Window]Q <Cmd>quit!<CR>
nnoremap [Window]o <C-W>o

" Commands of window split.
nnoremap [Window]s <C-W>s
nnoremap [Window]v <C-W>v
nnoremap [Window]n <C-W>n

" Window size controls.
nnoremap [Window]+ <C-W>+
nnoremap [Window]- <C-W>-
nnoremap [Window]= <C-W>=
nnoremap [Window]< <C-W><
nnoremap [Window]> <C-W>>

" Another window size controls.
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>
" }}}

" File save keybinds. {{{
nnoremap [Save] <Nop>
nmap <Space>s [Save]
nnoremap [Save]a <Cmd>wall<CR>
nnoremap [Save]q <Cmd>wq<CR>
nnoremap [Save]w <Cmd>write<CR>
nnoremap [Save]u <Cmd>update<CR>
" }}}

" Normal Mode:{{{
" US Keyboard layout mapping.
" Exchange Colon and Semi-Colon.
" nnoremap ; :
nnoremap : ;
nnoremap q; q:


" Do not save the things erased by x and c in the register.
nnoremap x "_x
nnoremap c "_c

" For vim-sandwich.
" nnoremap s <Nop>

" Opens the file name under the cursor.
nnoremap gf gF

" Disable highlights from search results.
nnoremap <Space>n <Cmd>nohlsearch<CR>

" }}}

" Insert Mode:{{{

" Exit insert mode.
inoremap jj <ESC>
inoremap <C-l> <Del>

" Add Emacs-like keybindings to insert mode.
" When one line only...
inoremap <C-a> <C-o>^
inoremap <C-e> <C-o>$
inoremap <C-f> <C-G>U<Right>
inoremap <C-b> <C-G>U<Left>
" }}}

" Visual Mode:{{{

" Exchange Colon and Semi-Colon.
" xnoremap ; :
xnoremap : ;


" Do not save the things erased by x and c in the register.
xnoremap x "_x
xnoremap c "_c

" }}}

" Command {{{

" Clean Register command {{{
function! s:Clear_Register() abort
    let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
    for r in regs
      call setreg(r, [])
    endfor
endfunction

command! Cleareg call s:Clear_Register()
" }}}

" Check for plugin updates on github graphQL api.{{{
" GitHub apt token file.
let s:github_pat = g:base_dir . 'github_pat'
if filereadable(s:github_pat)
  let g:dein#install_github_api_token = readfile(s:github_pat)[0]
  let s:exists_github_pat = v:true
else
  let s:exists_github_pat = v:false
endif

function! s:dein_update(bang_flg) abort
  if s:exists_github_pat && a:bang_flg == 0
    lua vim.notify('exists github_pat', 'info')
    call dein#check_update(v:true)
  elseif a:bang_flg
    lua vim.notify('use bang flag', 'info')
    call dein#update()
  else
    lua vim.notify('not exists github_pat', 'info')
    call dein#update()
  endif
endfunction

command! -bang DeinUpdate call s:dein_update(<bang>0)
" }}}

" dein.vim remove plugins.{{{
function! s:dein_check_uninstall() abort
  let remove_plugins = dein#check_clean()
  if len(l:remove_plugins) > 0
    for remove_plugin in remove_plugins
      echo remove_plugin
    endfor
    echo 'Would you like to remove those plugins?'
    echon '[Y/n]'
    if getcharstr() == 'y'
      call map(remove_plugins, "delete(v:val, 'rf')")
      call dein#recache_runtimepath()
      echo 'Remove Plugins ...done!'
    else 
      echo 'Remove Plugins ...abort!'
    endif
  else
    echo 'There are no plugins to remove.'
  endif
endfunction

command! DeinDelete call s:dein_check_uninstall()
" }}}

" dein cache scripts cleanup {{{
command! -bar DeinRecache call dein#recache_runtimepath() | qall
" }}}

" }}}
