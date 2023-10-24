local M = {}

-- local conditions = require("heirline.conditions")
-- local utils = require("heirline.utils")

local heirline = require("heirline")
local color = require("user.plugins.heirline.color")
local Statusline = require("user.plugins.heirline.statusline")

function M.setup()
    heirline.load_colors(color)
    heirline.setup({
        statusline = Statusline,
    })
end

return M
