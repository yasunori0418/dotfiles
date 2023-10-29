local Mode = require("user.plugins.heirline.mode")

return {
    {
        init = function(self)
            self.mode_colors = require("user.plugins.heirline.color").mode_colors()
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
        {
            provider = "\u{E0B0}",
            hl = function(self)
                return { fg = self.mode_colors.bg, bg = "bg0" }
            end,
        },
    },
}
