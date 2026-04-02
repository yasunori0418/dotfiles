-- lua_source {{{

--[[@type AiboConfig]]
local opts = {
    disable_startinsert_on_insert = true,
    disable_startinsert_on_startup = true,
    prompt_blend_insert = 10,
    prompt_blend_normal = 30,
    prompt_height = 10,
    prompt_title = " Ctrl+Enter: Submit | Esc: Close | Ctrl+C: Cancel ",
    submit_delay = 500,
    submit_key = "<CR>",
    termcode_mode = "hybrid",
}

require("aibo").setup(opts)

-- }}}
