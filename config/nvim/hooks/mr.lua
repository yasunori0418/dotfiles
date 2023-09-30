-- lua_add {{{
vim.g["mr#mru#predicates"] = {
    function(filename)
        return vim.regex([[COMMIT_EDITMSG]]):match_str(filename) == nil
    end,
}
-- }}}
