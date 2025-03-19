local M = {}

local insx = require("insx")
local with = insx.with

---insx.add with override
---@param recipe_source_like insx.RecipeSourceLike
---@param mode? insx.Mode[]
---@return fun(key: string, overrides?: insx.Override[])
function M.insx_override_add(recipe_source_like, mode)
    mode = mode or { "i", "c" }
    return function(key, overrides)
        overrides = overrides or {}
        insx.add(key, with(recipe_source_like, overrides), { mode = mode })
    end
end

---insx fast_wrap
---@param key string
---@param close string
---@param overrides? insx.Override[]
function M.fast_wrap(key, close, overrides)
    M.insx_override_add(
        require("insx.recipe.fast_wrap")({
            close = close,
        }),
        { "i" }
    )(key, overrides)
end

return M
