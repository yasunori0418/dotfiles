local M = {}

-- local conditions = require("heirline.conditions")
-- local utils = require("heirline.utils")

local heirline = require("heirline")
local Statusline = require("user.plugins.heirline.statusline")

function M.setup()
    require("user.plugins.heirline.color").set()
    heirline.setup({
        statusline = Statusline,
    })
end

return M
