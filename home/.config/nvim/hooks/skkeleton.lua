-- lua_add {{{
vim.keymap.set({ "i", "c" }, [[<C-j>]], [[<Plug>(skkeleton-toggle)]], { noremap = false })
-- }}}

-- lua_source {{{
local skkeleton_autocmds = vim.api.nvim_create_augroup("skkeleton_autocmds", { clear = true })
local skkeleton = require("user.plugins.skkeleton")

local skkeleton_dir = vim.fn.expand("~/.skk") --[[@as string]]
if vim.fn.isdirectory(skkeleton_dir) == 0 then
    vim.fn.mkdir(skkeleton_dir)
end

require("user.utils").autocmds_set({
    { -- skkeleton-initialize-pre
        events = "User",
        pattern = "skkeleton-initialize-pre",
        group = skkeleton_autocmds,
        callback = function()
            skkeleton.init()
        end,
    },
    { -- skkeleton-enable-pre
        events = "User",
        pattern = "skkeleton-enable-pre",
        group = skkeleton_autocmds,
        callback = function()
            skkeleton.pre()
        end,
    },
    { -- skkeleton-disable-pre
        events = "User",
        pattern = "skkeleton-disable-pre",
        group = skkeleton_autocmds,
        callback = function()
            skkeleton.post()
        end,
    },
    { -- redrawing(mode) on InsertLeave
        events = "InsertLeave",
        pattern = "*",
        group = skkeleton_autocmds,
        callback = function()
            vim.cmd([[mode]])
        end,
    },
})

-- vim.fn["skkeleton#initialize"]()
-- }}}
