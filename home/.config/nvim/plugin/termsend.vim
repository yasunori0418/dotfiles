" termsend.vim - コマンド定義
" Author: yasunori

" プラグインの重複読み込みを防ぐ
if exists('g:loaded_termsend_commands')
  finish
endif
let g:loaded_termsend_commands = 1

" コマンド定義
command! -nargs=0 TermSendOpen call termsend#open()
command! -nargs=0 TermSend call termsend#send()
command! -nargs=0 TermSendClose call termsend#close()
command! -nargs=0 TermSendFocusTerminal call termsend#focus_terminal()
command! -nargs=0 TermSendFocusMarkdown call termsend#focus_markdown()
