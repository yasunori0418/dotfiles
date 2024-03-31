local with_options = require("user.plugins.insx.with_options")

---@class AutoPairRule
---@diagnostic disable:duplicate-doc-field
---@field public open string
---@field public close string
---@field public options InsxWithOptions
---@field public new fun(rule: { open: string, close: string, options?: WithOptions }): AutoPairRule
local AutoPairRule = {}

---AutoPairRule initializer
---@param rule { open: string, close: string, options?: WithOptions }
---@return AutoPairRule
function AutoPairRule.new(rule)
    local obj = {
        open = rule.open,
        close = rule.close,
        options = with_options.new(rule.options or {}),
    }
    return setmetatable(obj, { __index = { AutoPairRule } })
end

return AutoPairRule
