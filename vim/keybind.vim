" Normal Mode
" init.vimを開く(init)
cnoremap init :edit $MYVIMRC<CR>
" スペース+wで保存
nnoremap <Space>w :w<CR>

" Insert Mode(Exit)
" ノーマルモードになりファイルを保存
inoremap <silent> jj <ESC>:w<CR>
" ESCを押したときに入力メソッドをOffにする
inoremap <silent> <ESC> <ESC>:call system('fcitx-remote -c')<CR>

" Insert Mode(Move)
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
inoremap <C-d> <BS>
