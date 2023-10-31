local M = {}

-- local conditions = require("heirline.conditions")
-- local utils = require("heirline.utils")

local heirline = require("heirline")

function M.setup()
    require("user.plugins.heirline.color").set()
    heirline.setup({
        statusline = require("user.plugins.heirline.statusline"),
        winbar = require("user.plugins.heirline.winbar"),
    })
end

return M
