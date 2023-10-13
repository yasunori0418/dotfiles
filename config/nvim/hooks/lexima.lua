-- lua_add {{{
vim.g["lexima_no_default_rules"] = true
vim.g["lexima_ctrlh_as_backspace"] = true
-- }}}

-- lua_source {{{
local lexima_util = require("user.plugins.lexima")
local utils = require("user.utils")

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

lexima_util.add_rules(global_rules)

local filetype_rules = {}

filetype_rules.python = {
    { char = [[_]], at = [[\W\+_\%#]], input = [[_]], input_after = [[__]] },
    { char = [[<BS>]], at = [[__\%#__]], input = [[<BS><BS>]], delete = 2 },
    { char = [[<Tab>]], at = [[\%#__]], leave = 2 },
}

filetype_rules.toml = {
    { char = [[<CR>]], at = [[=\s*'''\%#'''$]], input = [[<CR>]], input_after = [[<CR>]] },
    { char = [[<CR>]], at = [[=\s*"""\%#"""$]], input = [[<CR>]], input_after = [[<CR>]] },
}

for filetype, rules in pairs(filetype_rules) do
    vim.api.nvim_create_autocmd("FileType", {
        pattern = filetype,
        group = utils.vimrc_augroup,
        callback = function()
            lexima_util.add_rules(rules, tostring(filetype))
        end,
    })
end

lexima_util.altercmd([=[si\%[licon]]=], [[Silicon]])
lexima_util.altercmd([=[r\%[run]]=], [[QuickRun]])
lexima_util.altercmd([=[ma\%[son]]=], [[Mason]])
lexima_util.altercmd([[du]], [[DeinUpdate]])
lexima_util.altercmd([[rc]], [[Recache]])
lexima_util.altercmd([[ej]], [[Translate]]) -- 英語から日本語へ
lexima_util.altercmd([[je]], [[Translate!]]) -- 日本語から英語へ

-- }}}
