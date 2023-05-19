-- lua_add {{{
vim.g['mr#mru#predicates'] = {
  function(filename)
    vim.regex('COMMIT_EDITMSG'):match_str(filename)
  end,
}
-- }}}
