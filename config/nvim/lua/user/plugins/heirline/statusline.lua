local conditions = require("heirline.conditions")
local Mode = require("user.plugins.heirline.mode")
local File = require("user.plugins.heirline.file")
local Lsp = require("user.plugins.heirline.lsp")
local Align = { provider = "%=" }

local Left = {
    hl = { fg = "bg3" },
    { -- mode
        Mode.Vim,
        Mode.Skk,
        hl = function(self)
            return { bg = self.mode_colors.bg, bold = true }
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
            return " " .. vim.fn.fnamemodify(self.cwd, ":~")
        end,
        hl = function(self)
            return { bg = self.mode_colors.base, bold = true }
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
                return self.separator.sub.left
            end,
            hl = function(self)
                return { fg = self.mode_colors.base }
            end,
        },
    },
}

local Right = {
    { -- lsp server names
        condition = conditions.lsp_attached,
        { -- separator
            provider = function(self)
                return self.separator.sub.right
            end,
            hl = function(self)
                return { fg = self.mode_colors.fg }
            end,
        },
        Lsp.Names,
    },
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
