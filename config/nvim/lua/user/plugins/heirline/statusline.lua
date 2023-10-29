return {
    {
        init = function(self)
            self.mode_colors = require("user.plugins.heirline.color").mode_colors()
            self.padding_char = "\u{00A0}"
            self.separator = {
                main = {
                    left = "\u{E0B0}", -- [[]]
                    right = "\u{E0B2}", -- [[]]
                },
                sub = {
                    left = "\u{E0B1}", -- [[]]
                    right = "\u{E0B3}", -- [[]]
                }
            }
        end,
        hl = function(self)
            return { fg = self.mode_colors.fg, bg = self.mode_colors.bg }
        end,
        {
            require("user.plugins.heirline.mode"),
            hl = function(self)
                return { fg = "fg1", bg = self.mode_colors.bg }
            end,
        },
        {
            provider = function(self)
                return self.separator.main.left
            end,
            hl = function(self)
                return { fg = self.mode_colors.bg, bg = self.mode_colors.fg, }
            end,
        },
        { -- CWD
            provider = function(self)
                return self.padding_char .. vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
            end,
            hl = function(self)
                return { fg = "fg3", bg = self.mode_colors.fg }
            end
        },
        {
            provider = function(self)
                return self.separator.main.left
            end,
            hl = function(self)
                return { fg = self.mode_colors.fg, bg = "bg0" }
            end,
        },
    },
}
