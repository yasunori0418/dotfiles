local Mode = require("user.plugins.heirline.mode")
local color = require("user.plugins.heirline.color")

return {
    {
        init = function(self)
            self.mode_colors = color.mode_colors()
        end,
        hl = function(self)
            return { fg = self.mode_colors.fg, bg = self.mode_colors.bg }
        end,
        {
            Mode,
            hl = function(self)
                return { fg = "fg1", bg = self.mode_colors.bg }
            end,
        },
    },
}
