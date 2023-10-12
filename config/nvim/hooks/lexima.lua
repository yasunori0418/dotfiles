-- lua_add {{{
vim.g["lexima_no_default_rules"] = true
vim.g["lexima_ctrlh_as_backspace"] = true
-- }}}

-- lua_source {{{
local altercmd = require("user.plugins.lexima").altercmd
local utils = require("user.utils")
local add = vim.fn["lexima#add_rule"]

vim.fn["lexima#set_default_rules"]()

local global_rules = {
    { char = [[<]], input_after = [[>]] },
    { char = [[<BS>]], at = [[<\%#>]], delete = 1 },
    { char = [[>]], at = [[\%#>]], leave = [[>]] },
    { char = [[<Tab>]], at = [[\%#\s*>]], leave = [[>]] },
    { char = [[<Tab>]], at = [[\%#\s*"]], leave = [["]] },
    { char = [[<Tab>]], at = [[\%#\s*']], leave = [[']] },
    { char = [[<Tab>]], at = [[\%#\s*`]], leave = [[`]] },
    { char = [[<Tab>]], at = [=[\%#\s*]]=], leave = [=[]]=] },
    { char = [[<Tab>]], at = [[\%#\s*}]], leave = [[}]] },
    { char = [[<Tab>]], at = [[\%#\s*)]], leave = [[)]] },
}

for _, global_rule in ipairs(global_rules) do
    add(global_rule)
end

utils.autocmds_set({
    -- {
    --     events = { "FileType" },
    --     pattern = {},
    --     group = utils.vimrc_augroup,
    --     callback = function()
    --     end,
    -- },
    {
        events = { "FileType" },
        pattern = { "toml" },
        group = utils.vimrc_augroup,
        callback = function()
            add({
                mode = "i",
                char = [[<CR>]],
                at = [[=\s*'''\%#'''$]],
                input = [[<CR>]],
                input_after = [[<CR>]],
            })
            add({
                mode = "i",
                char = [[<CR>]],
                at = [[=\s*"""\%#"""$]],
                input = [[<CR>]],
                input_after = [[<CR>]],
            })
        end,
    },
})

altercmd([=[si\%[licon]]=], [[Silicon]])
altercmd([=[r\%[run]]=], [[QuickRun]])
altercmd([=[ma\%[son]]=], [[Mason]])
altercmd([[du]], [[DeinUpdate]])
altercmd([[rc]], [[Recache]])
altercmd([[ej]], [[Translate]]) -- 英語から日本語へ
altercmd([[je]], [[Translate!]]) -- 日本語から英語へ

-- }}}
