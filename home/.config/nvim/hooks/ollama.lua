-- lua_add {{{

vim.keymap.set("n", [[ ac]], function()
    vim.fn["ollama#start_chat"]("codellama:13b", {
        openner = "tabnew",
    })
end, {})

-- }}}

-- lua_source {{{

-- }}}
