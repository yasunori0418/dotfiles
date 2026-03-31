-- lua_source {{{
if vim.fn.has("mac") == 1 then
    local arto_bin = vim.fn.exepath("arto")
    if arto_bin ~= "" then
        local real_path = vim.fn.resolve(arto_bin) --[[@as str]]
        vim.g.arto_path = vim.fn.substitute(real_path, [[/Contents/MacOS/arto$]], "", "")
    end
end
-- }}}
