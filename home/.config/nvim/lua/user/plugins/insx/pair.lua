local M = {}
local helper = require("user.plugins.insx.helper")
local override_add = helper.insx_override_add
local insx = require("insx")
local esc = insx.esc

---insx auto_pair
---@param key string
---@param open string
---@param close string
---@param overrides? insx.Override[]
function M.auto_pair(key, open, close, overrides)
    override_add(require("insx.recipe.auto_pair")({
        open = open,
        close = close,
    }))(key, overrides)
end

---insx delete_pair
---@param key string
---@param open string
---@param close string
---@param overrides? insx.Override[]
function M.delete_pair(key, open, close, overrides)
    override_add(require("insx.recipe.delete_pair")({
        open_pat = esc(open),
        close_pat = esc(close),
    }))(key, overrides)
end

---insx jump_next
---@param key string
---@param close string
---@param overrides? insx.Override[]
function M.jump_pair_next(key, close, overrides)
    override_add(require("insx.recipe.jump_next")({
        jump_pat = [[\%#]] .. esc(close) .. [[\zs]],
    }))(key, overrides)
end

return M
