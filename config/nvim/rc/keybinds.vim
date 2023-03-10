" keybinds
" Nop keys
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

" Not use marker.
nnoremap m <Nop>
nnoremap ' <Nop>
nnoremap ` <Nop>

" Default space = right
nnoremap <Space> <Nop>
xnoremap <Space> <Nop>

" kill arrow key move
noremap <Left>    <Nop>
noremap <Down>    <Nop>
noremap <Up>      <Nop>
noremap <Right>   <Nop>
noremap! <Left>   <Nop>
noremap! <Down>   <Nop>
noremap! <Up>     <Nop>
noremap! <Right>  <Nop>

" Use prefix <Window>.
nnoremap <C-W> <Nop>


" Window control keybind
" File save
nnoremap <Window>w <Cmd>write<CR>

" Commands of move between window.
nnoremap <Window>h <C-W>h
nnoremap <Window>j <C-W>j
nnoremap <Window>k <C-W>k
nnoremap <Window>l <C-W>l

" Commands of move window.
nnoremap <Window>H <C-W>H
nnoremap <Window>J <C-W>J
nnoremap <Window>K <C-W>K
nnoremap <Window>L <C-W>L

" Tab page controls.
nnoremap [t gT
nnoremap ]t gt
nnoremap [T <Cmd>tabfirst<CR>
nnoremap ]T <Cmd>tablast<CR>
nnoremap tt <C-W>g<Tab>
nnoremap tT <C-W>T
nnoremap tn <Cmd>tabnew<CR>

" Commands of close window.
nnoremap <Window>q <C-W>q
nnoremap <Window>o <C-W>o

" Commands of window split.
nnoremap <Window>s <C-W>s
nnoremap <Window>v <C-W>v
nnoremap <Window>n <C-W>n

" Another window size controls.
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>


" Keybind prefixes
" Window control prefix
" overwrites window command of 'CTRL-W'.
nnoremap <Window> <Nop>
nmap <Space>w <Window>

" LSP keybinds prefix
nnoremap <lsp> <Nop>
nmap <Space>l <lsp>

" Git keybinds prefix
nnoremap <git>    <Nop>
nmap     <Space>g <git>


" Normal Mode:
" US Keyboard layout mapping.
" Exchange Colon and Semi-Colon.
"nnoremap ; :
nnoremap : ;
nnoremap q; q:

" Do not save the things erased by x and c in the register.
nnoremap x "_x
nnoremap c "_c

" Opens the file name under the cursor.
nnoremap gf gF

" Disable highlights from search results.
nnoremap <Space>n <Cmd>nohlsearch<CR>


" Insert Mode:
" Exit insert mode.
inoremap jj <ESC>
inoremap <C-l> <Del>

" Add Emacs-like keybindings to insert mode.
" When one line only...
inoremap <C-a> <C-o>^
" inoremap <C-e> <C-o>$ ~/dotfiles/config/nvim/toml/ddc.toml:122
inoremap <C-f> <C-G>U<Right>
inoremap <C-b> <C-G>U<Left>

" Visual Mode:
" Exchange Colon and Semi-Colon.
"xnoremap ; :
xnoremap : ;

" Do not save the things erased by x and c in the register.
xnoremap x "_x
xnoremap c "_c

xnoremap a' 2i'
xnoremap a" 2i"
xnoremap a` 2i`


" Operator Mode:
onoremap a' 2i'
onoremap a" 2i"
onoremap a` 2i`


" Quickfix
nnoremap [q <Cmd>cprevious<CR>
nnoremap ]q <Cmd>cnext<CR>
nnoremap [Q <Cmd>cfirst<CR>
nnoremap ]Q <Cmd>clast<CR>

" Buffer
nnoremap [b <Cmd>bprevious<CR>
nnoremap ]b <Cmd>bnext<CR>
nnoremap [B <Cmd>bfirst<CR>
nnoremap ]B <Cmd>blast<CR>

" Command line keybinds
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-l> <Del>

" Command
command! Cleareg call vimrc#clear_register()

command! -bang DeinUpdate call vimrc#dein_update(<bang>0)

command! DeinDelete call vimrc#dein_check_uninstall()

command! -bar DeinRecache call dein#recache_runtimepath() | qall

command! -bang DDCFuzzyFilter call vimrc#ddc_change_fileter(<bang>0, 'fuzzy')

command! -bang DDCNormalFilter call vimrc#ddc_change_fileter(<bang>0, 'normal')

command! DDCEchoFilter call vimrc#ddc_change_fileter(1, '')
command! ToggleSignColumn call vimrc#signcolumn()
