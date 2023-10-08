local M = {}
local utils = require("user.utils")

---@param path? string default: vim.fn.getcwd()
---@param split? string default: 'floating'
---@return table
function M.create_option(path, split)
    path = path or utils.search_repo_root()
    split = split or "floating"

    local winheight = ""
    if vim.regex([[floating\|horizontal]]):match_str(split) then
        winheight = "-winheight=" .. vim.fn.float2nr(vim.opt.lines:get() / 1.5)
    end

    local winwidth = ""
    if vim.regex([[floating\|vertical]]):match_str(split) then
        winwidth = "-winwidth=" .. vim.fn.float2nr(vim.opt.columns:get() / 1.5)
    end

    local deol_opt = {
        "Deol",
        "-no-auto-cd",
        "-no-start-insert",
        "-cwd=" .. path,
        "-split=" .. split,
        winwidth,
        winheight,
        "-toggle",
    }
    return vim.fn.map(deol_opt, function(_, value)
        return '"' .. value .. '"'
    end)
end

return M
