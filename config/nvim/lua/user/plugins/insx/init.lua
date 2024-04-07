-- local insx = require("insx")
-- local helper = require("insx.helper")
-- local esc = require("insx.helper.regex").esc
-- local jump_next = require("insx.recipe.jump_next")
-- local builtin_auto_pairs = require("insx.recipe.auto_pair")
-- local builtin_delete_pair = require("insx.recipe.delete_pair")

---@diagnostic disable-next-line:duplicate-doc-alias
---@alias InsxMode 'c'|'i'|'n'

local M = {}

---@param config { rules: AutoPairRuleTable[], keymaps: AutoPairKeymaps }
function M.auto_pairs_apply(config)
    local auto_pair_helper = require("user.plugins.insx.auto_pair")
    for _, rule in pairs(config.rules) do
        local auto_pair = auto_pair_helper.new(rule, config.keymaps)
        auto_pair_helper.apply(auto_pair)
    end
end

---@diagnostic disable-next-line:duplicate-doc-alias
---@alias AltercmdRuleTable { original: string, altanative: string }

---@param config { rules: AltercmdRuleTable[], keymaps: AltercmdKeymaps }
function M.altercmds_apply(config)
    local altercmd = require("user.plugins.insx.substitute").altercmd
    for _, rule in pairs(config.rules) do
        altercmd(rule.original, rule.altanative, config.keymaps)
    end
end

return M
