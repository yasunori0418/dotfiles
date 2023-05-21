-- lua_add {{{
vim.g['mr#mru#predicates'] = {
  function(filename)
    return filename ~= 'COMMIT_EDITMSG'
  end,
}
-- }}}
