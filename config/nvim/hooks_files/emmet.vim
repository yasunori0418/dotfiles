" hook_add {{{
let g:user_emmet_install_global = 0
let g:user_emmet_leader_key = '<C-k>'
autocmd FileType html,css,scss,php EmmetInstall
let g:user_emmet_settings = {
  \ 'variables': {
    \ 'lang': "ja"
    \ },
  \ 'html': {
    \ 'snippets': {
      \ 'html:5': "<!DOCTYPE html>\n"
      \ ."<html lang=\"${lang}\">\n"
      \ ."\t<head>\n"
      \ ."\t\t<meta charset=\"${charset}\">\n"
      \ ."\t\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n"
      \ ."\t\t<meta http-equiv=\"X-UA-Compatible\" content=\"ie=edge\">\n"
      \ ."\t\t<title></title>\n"
      \ ."\t\t<link rel=\"stylesheet\" href=\"css/style.css\">\n"
      \ ."\t</head>\n"
      \ ."\t<body>\n\t${child}|\n\t</body>\n"
      \ ."</html>",
      \ 'lrl:s': "{{ | }}",
      \ 'lrl:e': "{!! | !!}",
      \ }
    \ },
  \ 'php': {
    \ 'snippets': {
      \ 'php:s': "<?php | ?>",
      \ 'php:e': "<?= | ?>",
      \ 'lrl:s': "{{ | }}",
      \ 'lrl:e': "{!! | !!}",
      \ }
    \ }
\ }
" }}}
