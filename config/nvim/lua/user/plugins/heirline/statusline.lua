local Mode = require("user.plugins.heirline.mode")

return {
    {
        init = function(self)
            self.mode_colors = require("user.plugins.heirline.color").mode_colors()
            self.padding_char = "\u{00A0}"
            self.cwd = vim.fn.getcwd()
            self.separator = {
                main = {
                    left = "\u{E0B0}", -- [[]]
                    right = "\u{E0B2}", -- [[]]
                },
                sub = {
                    left = "\u{E0B1}", -- [[]]
                    right = "\u{E0B3}", -- [[]]
                },
            }
        end,
        { -- mode
            Mode.Vim,
            Mode.Skk,
            hl = function(self)
                return { fg = "bg3", bg = self.mode_colors.bg, bold = true }
            end,
        },
        { -- separator
            provider = function(self)
                return self.separator.main.left
            end,
            hl = function(self)
                return { fg = self.mode_colors.bg, bg = self.mode_colors.base }
            end,
        },
        { -- CWD
            provider = function(self)
                return self.padding_char .. vim.fn.fnamemodify(self.cwd, ":~")
            end,
            hl = function(self)
                return { fg = "bg3", bg = self.mode_colors.base }
            end,
        },
        { -- separator
            provider = function(self)
                return self.separator.main.left
            end,
            hl = function(self)
                return { fg = self.mode_colors.base, bg = "bg0" }
            end,
        },
        {
            require("user.plugins.heirline.git"),
        },
    },
}
