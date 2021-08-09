if &compatible
  set nocompatible
endif

" ========================
" dein.vim
" ========================
" dein directory {{{
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
" }}}

" dein installation check {{{
if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repo)
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo
    endif
    execute 'set runtimepath^=' . s:dein_repo
endif
" }}}

" Begin settings {{{
if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    " .toml files
    let s:rc_dir = expand('~/.vim')
    let s:dein_toml = s:rc_dir . '/dein.toml'
    let s:dein_lazy_toml = s:rc_dir . '/lazy.toml'
    let s:dein_ft_toml = s:rc_dir . '/filetype.toml'

    " read toml and cache
    call dein#load_toml(s:dein_toml, {'lazy': 0})
    call dein#load_toml(s:dein_lazy_toml, {'lazy': 1})
    call dein#load_toml(s:dein_ft_toml, {'lazy': 1})

    " end settings
    call dein#end()
    call dein#save_state()
endif
" }}}

" Plugin installation check {{{
if dein#check_install()
    call dein#install()
endif
" }}}

" ファイル形式別プラグインの有効
filetype plugin indent on
" シンタックスハイライトの有効
syntax enable


" ========================
" エディタ設定
" ========================
" 文字コード {{{
" 全体の文字コードをUTF-8
set encoding=utf-8
" ファイル書き込み時の文字コードをUTF-8
set fileencoding=utf-8
" ファイル読み込み時の文字コード
set fileencodings=utf-8,sjis,iso-2022-jp,euc-jp
" }}}
" 改行コードの自動認識
set fileformats=unix,dos,mac
" バックアップの無効化
set nobackup
" スワップファイルを作成しない
set noswapfile
" 全角文字専用の設定
set ambiwidth=double
" 編集中のファイルの自動読み込み
set autoread
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" クリップボードを使う
set clipboard+=unnamed
" カラースキーム
colorscheme iceberg
" mapleader
let mapleader = ' '

" ========================
" 表示設定
" ========================
" 行番号の表示
set number
" 相対行数の表示
set relativenumber
" カーソルラインを表示
set cursorline
" タイトル表示
set title
" RGBカラー設定
if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" ========================
" 検索関係
" ========================
" 検索結果をハイライト
set hlsearch
" インクリメント検索(検索ワードの最初の文字を入力した時点で検索が開始)
set incsearch
" 検索するときに大文字小文字を区別しない
set ignorecase
" 小文字で検索すると大文字と小文字を無視して検索
set smartcase
" 検索がファイル末尾まで進んだら、ファイル先頭から再び検索
set wrapscan

" ========================
" インデント関係
" ========================
" スマートインデント
set smartindent
" タブを半角スペースで挿入する
set expandtab
" 各コマンドやsmartindentで挿入する空白の量
set shiftwidth=4
" タブ幅をスペース4つにする
set tabstop=4
" 半角スペース4分のタブを挿入する
set softtabstop=4

" ========================
" ステータスライン関係
" ========================
" ステータスラインを表示
set laststatus=2
" コマンドライン補完
set wildmenu
" コマンド履歴
set history=5000

" ========================
" 不可視文字の表示
" ========================
set list
"タブ/行末スペース/改行/ノーブレークスペース
set listchars=tab:»-,trail:･,eol:↲,nbsp:%


" ========================
" キーバインド
" ========================

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
