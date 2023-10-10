-- lua_add {{{
vim.g["lexima_no_default_rules"] = true
vim.g["lexima_ctrlh_as_backspace"] = true
-- }}}

-- lua_source {{{
local altercmd = require("user.plugins.lexima").altercmd
vim.fn["lexima#set_default_rules"]()

altercmd([=[si\%[licon]]=], [[Silicon]])
altercmd([=[r\%[run]]=], [[QuickRun]])
altercmd([=[ma\%[son]]=], [[Mason]])
altercmd([[du]], [[DeinUpdate]])
altercmd([[rc]], [[Recache]])
altercmd([[ej]], [[Translate]]) -- 英語から日本語へ
altercmd([[je]], [[Translate!]]) -- 日本語から英語へ

-- }}}
