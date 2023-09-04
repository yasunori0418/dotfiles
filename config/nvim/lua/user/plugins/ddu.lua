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

return M
