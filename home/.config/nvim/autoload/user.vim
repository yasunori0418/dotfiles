function! user#dump_qflist(bufname = 'qflist.dump') abort
  const bufnr = a:bufname->bufadd()
  call bufload(bufnr)
  call getqflist()
    \ ->map({_, val -> $'{bufname(val['bufnr'])}:{val['lnum']}:{val['col']}:{val['text']}'})
    \ ->setbufline(bufnr, 1)
  call setbufvar(bufnr, '&buflisted', v:true)
  call buflisted(bufnr)
  execute $'buffer {bufnr}'
endfunction
