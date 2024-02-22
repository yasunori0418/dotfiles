function! gh_project#create_scratch_buffer(name)
  let bufname = $'gh_project://{a:name}'->bufadd()->bufname()
  call setbufvar(bufname, '&buftype', 'nofile')
  call setbufvar(bufname, '&bufhidden', 'hide')
  call setbufvar(bufname, '&swapfile', v:false)
  return #{ bufnr: bufnr(bufname), bufname: bufname }
endfunction
