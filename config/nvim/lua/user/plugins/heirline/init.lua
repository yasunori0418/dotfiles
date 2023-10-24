local M = {}

-- local conditions = require("heirline.conditions")
-- local utils = require("heirline.utils")

local heirline = require("heirline")
local palette = require("user.plugins.heirline.color")
local Statusline = require("user.plugins.heirline.statusline")

function M.setup()
    heirline.load_colors(palette.colors)
    heirline.setup({
        statusline = Statusline,
    })
end

return M
