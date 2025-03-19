local M = {}
local helper = require("user.plugins.insx.helper")
local override_add = helper.insx_override_add
local insx = require("insx")
local esc = insx.esc

---insx auto_pair
---@param key string
---@param quote string
---@param overrides? insx.Override[]
function M.auto_quote(key, quote, overrides)
    override_add(require("insx.recipe.auto_pair")({
        open = quote,
        close = quote,
    }))(key, overrides)
end

---insx delete_pair
---@param key string
---@param quote string
---@param overrides? insx.Override[]
function M.delete_quote(key, quote, overrides)
    override_add(require("insx.recipe.delete_pair")({
        open_pat = esc(quote),
        close_pat = esc(quote),
    }))(key, overrides)
end

---insx jump_next
---@param key string
---@param quote string
---@param overrides? insx.Override[]
function M.jump_quote_next(key, quote, overrides)
    override_add(require("insx.recipe.jump_next")({
        jump_pat = [[\\\@<!\%#]] .. esc(quote) .. [[\zs]],
    }))(key, overrides)
end

return M
