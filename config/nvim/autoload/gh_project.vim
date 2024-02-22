function! gh_project#create_scratch_buffer(name)
  let bufname = $'gh_project://{a:name}'->bufadd()->bufname()
  call setbufvar(bufname, '&buftype', 'nofile')
  call setbufvar(bufname, '&bufhidden', 'hide')
  call setbufvar(bufname, '&swapfile', v:false)
  return #{ bufnr: bufnr(bufname), bufname: bufname }
endfunction

function! gh_project#open_buffer(bufnr, split_kind)
  if a:split_kind ==# 'horizontal'
    execute $'split +buffer{a:bufnr}'
  elseif a:split_kind ==# 'vertical'
    execute $'vsplit +buffer{a:bufnr}'
  endif
endfunction
