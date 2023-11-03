local conditions = require("heirline.conditions")
local Mode = require("user.plugins.heirline.mode")
local File = require("user.plugins.heirline.file")
local Align = { provider = "%=" }

local Left = {
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
            return { fg = self.mode_colors.base }
        end,
    },
    {
        condition = conditions.is_git_repo,
        require("user.plugins.heirline.git"),
        { --separator
            provider = function(self)
                return self.separator.sub.left .. self.separator.sub.left
            end,
            hl = function(self)
                return { fg = self.mode_colors.base, bg = "bg0" }
            end,
        },
    },
}

local Right = {
    hl = { bg = "bg0" },
    { -- separator
        provider = function(self)
            return self.separator.sub.right
        end,
        hl = function(self)
            return { fg = self.mode_colors.base }
        end,
    },
    { -- Ruler
        require("user.plugins.heirline.ruler"),
        hl = function(self)
            return { fg = self.mode_colors.base }
        end,
    },
    { -- separator
        provider = function(self)
            return self.separator.sub.right
        end,
        hl = function(self)
            return { fg = self.mode_colors.bg }
        end,
    },
    {
        File.InfoBlock,
        hl = function(self)
            return { fg = self.mode_colors.bg, bold = true }
        end,
    },
}

return {
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
    hl = { bg = "bg0" },
    Left,
    Align,
    Right,
}
