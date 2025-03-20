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

function M.altercmd(original, altanative)
    ---@type insx.recipe.substitute.Option
    local options = {
        pattern = [[\v(^|'<, '>)]] .. original .. [[\%#]],
        replace = [[\1]] .. altanative .. [[ \%#]],
    }
    local recipe = require("insx.recipe.substitute")(options)
    ---@param ctx insx.Context
    recipe.enabled = function(ctx)
        return vim.fn.getcmdtype() == ":" and ctx.match(options.pattern)
    end
    M.insx_override_add(recipe, { "c" })("<Space>")
end

return M
