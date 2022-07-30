" Performance improvements using lua.
"let g:lsp_use_lua = v:true

" enable signs
"let g:lsp_signs_enabled = 1

" Not use virtual text.
"let g:lsp_diagnostics_virtual_text_enabled = 0

" Use echo from cmdline.
"let g:lsp_diagnostics_echo_cursor = 1

" diagnostics signs
"let g:lsp_diagnostics_signs_error = {'text': '✗'}
"let g:lsp_diagnostics_signs_warning = {'text': ''}
"let g:lsp_diagnostics_signs_information = {'text': ''}
"let g:lsp_diagnostics_signs_hint = {'text': ''}

" Document code action sign.
"let g:lsp_document_code_action_signs_hint = {'text': ''}

"let g:lsp_diagnostics_virtual_text_prefix = ''
"let g:lsp_tree_incoming_prefix = ''

" output lsp log file
let g:lsp_log_file = expand('~/vim-lsp.log')

" efm-langserver settings {{{

" https://github.com/nakatanakatana/dotfiles
" for efm-langserver-settings
let s:efm_args = []
if efm_langserver_settings#config_enable()
  let s:efm_args = extend(s:efm_args, ['-c', efm_langserver_settings#config_path()])
endif

let g:efm_langserver_settings#debug = 5

if efm_langserver_settings#debug_enable()
  let s:efm_args = extend(s:efm_args, ['-logfile', efm_langserver_settings#debug_path()])
  let s:efm_args = extend(s:efm_args, ['-loglevel', efm_langserver_settings#debug_enable()])
endif

let g:lsp_settings = {
  \ 'efm-langserver': {
    \ 'disabled': v:false,
    \ 'args': s:efm_args,
    \ 'allowlist': efm_langserver_settings#whitelist(),
    \ 'blocklist': efm_langserver_settings#blacklist(),
    \ }
  \ }

" }}}

" Not show install server suggestion message.
let g:lsp_settings_enable_suggestions = 0
