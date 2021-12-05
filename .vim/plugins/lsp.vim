" Performance improvements using lua.
let g:lsp_use_lua = v:true

" Not use virtual text.
let g:lsp_diagnostics_virtual_text_enabled = 0

" Use echo from cmdline.
let g:lsp_diagnostics_echo_cursor = 1

" diagnostics signs
let g:lsp_diagnostics_signs_error = {'text': '✗'}
let g:lsp_diagnostics_signs_warning = {'text': ''}
let g:lsp_diagnostics_signs_information = {'text': ''}
let g:lsp_diagnostics_signs_hint = {'text': ''}

" Document code action sign.
let g:lsp_document_code_action_signs_hint = {'text': '﭅'}

" let g:lsp_diagnostics_virtual_text_prefix = ''
" let g:lsp_tree_incoming_prefix = ''
