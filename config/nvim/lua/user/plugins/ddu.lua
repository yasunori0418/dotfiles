local M = {}

---@param items table[] DduItem[]
---@param index number
---@return boolean
local function is_dummy(items, index)
    return items[index] and items[index].__sourceName == "dummy"
end

---@param dir number
function M.move_ignore_dummy(dir)
    local items = vim.fn["ddu#ui#get_items"]()
    local index = vim.fn.line(".") + dir

    while is_dummy(items, index) do
        index = index + dir
    end
    if 1 <= index and index <= #items then
        vim.cmd("normal! " .. index .. "gg")
    end
end

function M.start_filter_once()
    vim.api.nvim_create_autocmd("User", {
        pattern = "Ddu:uiDone",
        callback = function()
            -- vim.fn["ddu#ui#async_action"]("openFilterWindow")
            vim.fn.timer_start(0, function()
                vim.fn["ddu#ui#sync_action"]("openFilterWindow")
            end)
        end,
        once = true,
        nested = true,
    })
end

return M
