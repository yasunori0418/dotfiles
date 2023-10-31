local M = {}

-- local conditions = require("heirline.conditions")
-- local utils = require("heirline.utils")

local heirline = require("heirline")
local conditions = require("heirline.conditions")

function M.setup()
    require("user.plugins.heirline.color").set()
    heirline.setup({
        statusline = require("user.plugins.heirline.statusline"),
        winbar = require("user.plugins.heirline.winbar"),
        opts = {
            -- if the callback returns true, the winbar will be disabled for that window
            -- the args parameter corresponds to the table argument passed to autocommand callbacks.
            -- :h nvim_lua_create_autocmd()
            disable_winbar_cb = function(args)
                return conditions.buffer_matches({
                    buftype = { "nofile", "prompt", "help", "quickfix", "terminal" },
                    filetype = { "^git.*", "^ddu.*", "^gin.*", "qfreplace" },
                }, args.buf)
            end,
        },
    })
end

return M
