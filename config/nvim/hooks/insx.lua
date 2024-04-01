-- lua_source {{{

-- require("insx.preset.standard").setup({
--     cmdline = {
--         enabled = true,
--     },
--     fast_break = {
--         enabled = true,
--     },
--     fast_wrap = {
--         enabled = true,
--     },
--     spacing = {
--         enabled = true,
--     },
-- })

local auto_pair_config = {}

---@type AutoPairRuleTable[]
auto_pair_config.rules = {
    {
        open = [[(]],
        close = [[)]],
        options = {
            undopoint = true,
            nomatch = [[\%#\w]],
        },
        fast_break = {
            arguments = true,
            html_attrs = true,
            html_tags = true,
        },
    },
    {
        open = [[{]],
        close = [[}]],
        options = {
            undopoint = true,
            nomatch = [[\%#\w]],
        },
        fast_break = {
            arguments = true,
            html_attrs = true,
            html_tags = true,
        },
    },
    {
        open = [=[[]=],
        close = [=[]]=],
        options = {
            undopoint = true,
            nomatch = [[\%#\w]],
        },
        fast_break = {
            arguments = true,
            html_attrs = true,
            html_tags = true,
        },
    },
}

---@type AutoPairKeymaps
auto_pair_config.keymaps = {
    jump_next_extra = { "<Tab>" },
    delete_pair = { "<BS>", "<C-h>" },
    spacing = {
        increase = { "<Space>" },
        decrease = { "<BS>", "<C-h>" },
    },
    fast_break = { "<CR>" },
    fast_wrap = { "<C-]>" },
}

local auto_pair_helper = require("user.plugins.insx.auto_pair")
for _, auto_pair in pairs(auto_pair_config.rules) do
    local rule = auto_pair_helper.new(auto_pair, auto_pair_config.keymaps)
    auto_pair_helper.apply(rule)
end

-- }}}
