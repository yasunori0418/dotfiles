---@diagnostic disable-next-line:duplicate-doc-alias
---@alias FastBreakOption { arguments?: boolean, html_attrs?: boolean, html_tags?: boolean, indent?: integer }

-- luacheck: push no_max_comment_line_length
---@diagnostic disable-next-line:duplicate-doc-alias
---@alias AutoPairKeymaps { jump_next_extra: string[], delete_pair: string[], spacing: { increase: string[], decrease: string[] }, fast_break: string[], fast_wrap: string[] }
-- luacheck: pop

---@diagnostic disable-next-line:duplicate-doc-alias
---@alias AutoPairRuleTable { open: string, close: string, with_option?: insx.Override[], fast_break?: FastBreakOption }

---@class AutoPairRule
---@diagnostic disable:duplicate-doc-field
---@field public open string
---@field public close string
---@field public with_option insx.Override[]
---@field public fast_break FastBreakOption
---@field public keymaps AutoPairKeymaps
---@field public new fun(rule: AutoPairRuleTable, keymaps: AutoPairKeymaps ): AutoPairRule
---@field public apply fun(self: AutoPairRule)
local AutoPairRule = {}

---AutoPairRule initializer
---@param rule AutoPairRuleTable
---@param keymaps AutoPairKeymaps
---@return AutoPairRule
function AutoPairRule.new(rule, keymaps)
    local obj = {
        open = rule.open,
        close = rule.close,
        with_option = rule.with_option or {},
        fast_break = {
            arguments = rule.fast_break.arguments or false,
            html_attrs = rule.fast_break.html_tags or false,
            html_tags = rule.fast_break.html_tags or false,
            indent = rule.fast_break.indent or 1,
        },
        keymaps = keymaps,
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
            self.with_option
        )
    )

    -- jump_next
    insx.add(
        self.close,
        require("insx.recipe.jump_next")({
            jump_pat = {
                [[\%#]] .. esc(self.close) .. [[\zs]],
            },
        })
    )
    for _, keymap in pairs(self.keymaps.jump_next_extra) do
        insx.add(
            keymap,
            require("insx.recipe.jump_next")({
                jump_pat = {
                    [[\%#]] .. esc(self.close) .. [[\zs]],
                },
            })
        )
    end

    -- delete_pair
    for _, keymap in pairs(self.keymaps.delete_pair) do
        insx.add(
            keymap,
            require("insx.recipe.delete_pair")({
                open_pat = esc(self.open),
                close_pat = esc(self.close),
            })
        )
    end

    -- spacing
    for _, keymap in pairs(self.keymaps.spacing.increase) do
        insx.add(
            keymap,
            require("insx.recipe.pair_spacing").increase({
                open_pat = esc(self.open),
                close_pat = esc(self.close),
            })
        )
    end
    for _, keymap in pairs(self.keymaps.spacing.decrease) do
        insx.add(
            keymap,
            require("insx.recipe.pair_spacing").decrease({
                open_pat = esc(self.open),
                close_pat = esc(self.close),
            })
        )
    end

    -- fast_break
    for _, keymap in pairs(self.keymaps.fast_break) do
        insx.add(
            keymap,
            require("insx.recipe.fast_break")({
                open_pat = esc(self.open),
                close_pat = esc(self.close),
                arguments = self.fast_break.arguments,
                html_attrs = self.fast_break.html_attrs,
                html_tags = self.fast_break.html_tags,
                indent = self.fast_break.indent,
            })
        )
    end

    -- fast_wrap
    for _, keymap in pairs(self.keymaps.fast_wrap) do
        insx.add(
            keymap,
            require("insx.recipe.fast_wrap")({
                close = self.close,
            })
        )
    end
end

return AutoPairRule
