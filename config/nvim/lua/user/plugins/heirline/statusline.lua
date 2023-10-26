local Mode = require("user.plugins.heirline.mode")

return {
    {
        init = function(_)
        end,
        {
            Mode,
            hl = function(_)
                return { fg = "fg2", bg = "blue_dim" }
            end,
        },
    },
}
