-- lua_add {{{
vim.g["mr#mru#predicates"] = {
    function(filename)
        local excludes = vim.iter({ "COMMIT_EDITMSG", "git-rebase-todo" }):join("|")
        return vim.regex([[\v]] .. excludes):match_str(filename) == nil
    end,
}
-- }}}
