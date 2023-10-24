local Mode = require("user.plugins.heirline.mode")

return {
    {
        init = function(_)
        end,
        {
            Mode,
            hl = function(_)
                return { fg = "bright_fg", bg = "green" }
            end,
        },
    },
}
