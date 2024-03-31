local with_options = require("user.plugins.insx.with_options")

---@diagnostic disable-next-line:duplicate-doc-alias
---@alias FastBreakOption { arguments?: boolean, html_attrs?: boolean, html_tags?: boolean, indent?: integer }

---@class AutoPairRule
---@diagnostic disable:duplicate-doc-field
---@field public open string
---@field public close string
---@field public options InsxWithOptions
---@field public fast_break FastBreakOption
-- luacheck: push no_max_comment_line_length
---@field public new fun(rule: { open: string, close: string, options?: WithOptions, fast_break?: FastBreakOption }): AutoPairRule
-- luacheck: pop
---@field public apply fun(self: AutoPairRule)
local AutoPairRule = {}

---AutoPairRule initializer
---@param rule { open: string, close: string, options?: WithOptions|nil, fast_break?: FastBreakOption|nil }
---@return AutoPairRule
function AutoPairRule.new(rule)
    local obj = {
        open = rule.open,
        close = rule.close,
        options = with_options.new(rule.options or {}),
        fast_break = {
            arguments = rule.fast_break.arguments or false,
            html_attrs = rule.fast_break.html_tags or false,
            html_tags = rule.fast_break.html_tags or false,
            indent = rule.fast_break.indent or 1,
        },
    }
    return setmetatable(obj, { __index = { AutoPairRule } })
end

function AutoPairRule.apply(self)
    local insx = require("insx")
    local esc = require("insx.helper.regex").esc

    -- auto_pair
    insx.add(
        self.open,
        insx.with(
            require("insx.recipe.auto_pair")({
                open = self.open,
                close = self.close,
            }),
            self.options:overrides()
        )
    )

    -- delete_pair
    insx.add(
        "<BS>",
        require("insx.recipe.delete_pair")({
            open_pat = esc(self.open),
            close_pat = esc(self.close),
        })
    )
    insx.add(
        "<C-h>",
        require("insx.recipe.delete_pair")({
            open_pat = esc(self.open),
            close_pat = esc(self.close),
        })
    )

    -- spacing
    insx.add(
        "<Space>",
        require("insx.recipe.pair_spacing").increase({
            open_pat = esc(self.open),
            close_pat = esc(self.close),
        })
    )
    insx.add(
        "<BS>",
        require("insx.recipe.pair_spacing").decrease({
            open_pat = esc(self.open),
            close_pat = esc(self.close),
        })
    )
    insx.add(
        "<C-h>",
        require("insx.recipe.pair_spacing").decrease({
            open_pat = esc(self.open),
            close_pat = esc(self.close),
        })
    )

    -- fast_break
    insx.add(
        "<CR>",
        require("insx.recipe.fast_break")({
            open_pat = esc(self.open),
            close_pat = esc(self.close),
            arguments = self.fast_break.arguments,
            html_attrs = self.fast_break.html_attrs,
            html_tags = self.fast_break.html_tags,
            indent = self.fast_break.indent,
        })
    )

    -- fast_wrap
    insx.add(
        "<C-]",
        require("insx.recipe.fast_wrap")({
            close = self.close,
        })
    )
end

return AutoPairRule
