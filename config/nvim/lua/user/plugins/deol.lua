local M = {}

---@alias deol_split_kinds
---| "" # No split
---| "floating" # Use neovim floating window feature
---| "vertical" # Split buffer vertically
---| "farleft" # Split buffer far left, like |CTRL-W_H|
---| "farright" # Split buffer far right, like |CTRL-W_L|
---| "horizontal" # Split buffer horizontally

---@param cwd? string default: require("user.utils").search_repo_root()
---@param split? deol_split_kinds default: 'floating'
---@param ratio? integer default: 0.6
function M.open(cwd, split, ratio)
    cwd = cwd or require("user.utils").search_repo_root()
    split = split or "floating"
    ratio = ratio or 0.6

    local winheight
    if vim.regex([[floating\|horizontal]]):match_str(split) then
        winheight = vim.fn.float2nr(vim.opt.lines:get() * ratio)
    end

    local winwidth
    if vim.regex([[floating\|vertical\|farleft\|farright]]):match_str(split) then
        winwidth = vim.fn.float2nr(vim.opt.columns:get() * ratio)
    end

    vim.fn["deol#start"]({
        auto_cd = false,
        cwd = cwd,
        dir_changed = false,
        edit = false,
        split = split,
        start_insert = false,
        toggle = false,
        winheight = winheight,
        winwidth = winwidth,
    })
end

return M
