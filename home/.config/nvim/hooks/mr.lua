-- lua_add {{{
vim.g["mr#mru#predicates"] = {
    function(filename)
        return vim.regex([[\vCOMMIT_EDITMSG|git-rebase-todo]]):match_str(filename) == nil
    end,
}
-- }}}
