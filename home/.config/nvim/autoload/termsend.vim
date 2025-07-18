" termsend.vim - Terminal送信プラグイン
" Author: yasunori
" Description: ターミナルに対して複数行の文字列を送信するプラグイン

" グローバル変数
let s:term_channel_id = -1
let s:term_buffer_nr  = -1
let s:md_buffer_nr    = -1
let s:md_window_id    = -1
let s:term_window_id  = -1

" プラグインの初期化チェック
if exists('g:loaded_termsend')
  finish
endif
let g:loaded_termsend = 1

" ターミナルとmarkdownバッファを起動する関数
function! termsend#open() abort
  " 既に開いている場合はフォーカスのみ
  if s:term_channel_id != -1 && bufexists(s:term_buffer_nr)
    call win_gotoid(s:md_window_id)
    return
  endif

  " 水平分割でターミナルを起動
  split
  terminal

  " ターミナルの情報を保存
  let s:term_buffer_nr = bufnr('%')
  let s:term_channel_id = b:terminal_job_id
  let s:term_window_id = win_getid()

  " ターミナルウィンドウのサイズを調整（上部2/3）
  resize +5

  " markdownバッファを下部に作成
  split
  enew

  " markdownバッファの設定
  setlocal buftype=nofile
  setlocal bufhidden=wipe
  setlocal noswapfile
  setlocal filetype=markdown

  " バッファ名を設定
  file [TermSend-Markdown]

  " markdownバッファの情報を保存
  let s:md_buffer_nr = bufnr('%')
  let s:md_window_id = win_getid()

  " markdownバッファにフォーカス
  call win_gotoid(s:md_window_id)

  " バッファローカルマッピング
  nnoremap <buffer> <silent> <Leader>ts :call termsend#send()<CR>

  " バッファローカルコマンド
  command! -buffer TermSendClear call s:clear_markdown_buffer()
  command! -buffer TermSendFocus call termsend#focus_terminal()

  " カーソルを末尾に移動
  normal! G

  echo "TermSend: ターミナルとmarkdownバッファを開きました"
endfunction

" markdownバッファの内容をターミナルに送信する関数
function! termsend#send() abort
  " ターミナルが存在するかチェック
  if s:term_channel_id == -1 || !bufexists(s:term_buffer_nr)
    echohl ErrorMsg
    echo "TermSend: ターミナルが開かれていません。:TermSendOpen を実行してください。"
    echohl None
    return
  endif

  " 現在のバッファがmarkdownバッファかチェック
  if bufnr('%') != s:md_buffer_nr
    echohl ErrorMsg
    echo "TermSend: markdownバッファから実行してください。"
    echohl None
    return
  endif

  " バッファの全内容を取得
  const lines = getline(1, '$')

  " 空行のみの場合は送信しない
  if lines->copy()->filter('v:val !~ "^\\s*$"')->empty()
    echo "TermSend: 送信する内容がありません。"
    return
  endif


  " 各行を改行で結合し、最後に改行を追加
  let content = lines->join("\n") . "\n"
  call chansend(s:term_channel_id, content)

  echo "TermSend: 内容を送信しました (" . lines->len() . " 行)"
endfunction

" ターミナルセッションを閉じる関数
function! termsend#close() abort
  " markdownバッファを閉じる
  if s:md_buffer_nr != -1 && bufexists(s:md_buffer_nr)
    execute 'bwipeout! ' . s:md_buffer_nr
  endif

  " ターミナルバッファを閉じる
  if s:term_buffer_nr != -1 && bufexists(s:term_buffer_nr)
    execute 'bwipeout! ' . s:term_buffer_nr
  endif

  " 変数をリセット
  let s:term_channel_id = -1
  let s:term_buffer_nr  = -1
  let s:md_buffer_nr    = -1
  let s:md_window_id    = -1
  let s:term_window_id  = -1

  echo "TermSend: セッションを閉じました"
endfunction

" ターミナルウィンドウにフォーカスする関数
function! termsend#focus_terminal() abort
  if s:term_window_id != -1 && win_id2win(s:term_window_id) != 0
    call win_gotoid(s:term_window_id)
  else
    echo "TermSend: ターミナルウィンドウが見つかりません"
  endif
endfunction

" markdownウィンドウにフォーカスする関数
function! termsend#focus_markdown() abort
  if s:md_window_id != -1 && win_id2win(s:md_window_id) != 0
    call win_gotoid(s:md_window_id)
  else
    echo "TermSend: markdownウィンドウが見つかりません"
  endif
endfunction

" ========================================
" 補助関数（スクリプトローカル）
" ========================================

" markdownバッファをクリアする関数
function! s:clear_markdown_buffer() abort
  " 現在のバッファがmarkdownバッファかチェック
  if bufnr('%') != s:md_buffer_nr
    echo "TermSend: markdownバッファで実行してください"
    return
  endif
  
  " バッファの内容をクリア
  silent! normal! ggdG
  echo "TermSend: バッファをクリアしました"
endfunction
