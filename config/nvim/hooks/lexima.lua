-- lua_add {{{
vim.g["lexima_no_default_rules"] = true
vim.g["lexima_ctrlh_as_backspace"] = true
-- }}}

-- lua_source {{{
local lexima_util = require("user.plugins.lexima")
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
        pattern = { "python" },
        group = utils.vimrc_augroup,
        callback = function()
            add({
                char = [[_]],
                at = [[\W\+_\%#]],
                input = [[_]],
                input_after = [[__]],
            })
            add({
                char = [[<BS>]],
                at = [[__\%#__]],
                input = [[<BS><BS>]],
                delete = 2,
            })
            add({
                char = [[<Tab>]],
                at = [[\%#__]],
                leave = 2,
            })
        end,
    },
    {
        events = { "FileType" },
        pattern = { "toml" },
        group = utils.vimrc_augroup,
        callback = function()
            add({
                char = [[<CR>]],
                at = [[=\s*'''\%#'''$]],
                input = [[<CR>]],
                input_after = [[<CR>]],
            })
            add({
                char = [[<CR>]],
                at = [[=\s*"""\%#"""$]],
                input = [[<CR>]],
                input_after = [[<CR>]],
            })
        end,
    },
})

lexima_util.altercmd([=[si\%[licon]]=], [[Silicon]])
lexima_util.altercmd([=[r\%[run]]=], [[QuickRun]])
lexima_util.altercmd([=[ma\%[son]]=], [[Mason]])
lexima_util.altercmd([[du]], [[DeinUpdate]])
lexima_util.altercmd([[rc]], [[Recache]])
lexima_util.altercmd([[ej]], [[Translate]]) -- 英語から日本語へ
lexima_util.altercmd([[je]], [[Translate!]]) -- 日本語から英語へ

-- }}}
