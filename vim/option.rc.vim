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



