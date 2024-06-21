local M = {}

---current_line_blame_formatter
---@param name string
---@param blame_info Gitsigns.BlameInfoPublic
---@return {[1]:string,[2]:"GitSignsCurrentLineBlame"}[]
function M.blame_line_formatter(name, blame_info)
    if name == blame_info.author then
        return {{[1] = "", [2] = "GitSignsCurrentLineBlame"}}
    end
    local text = blame_info.author .. ":" .. blame_info.abbrev_sha .. " - " .. blame_info.summary
    return {{[1] = text, [2] = "GitSignsCurrentLineBlame"}}
end

return M
