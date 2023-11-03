return {
    init = function(self)
        self.mode_colors = require("user.plugins.heirline.color").mode_colors()
    end,
    hl = function()
        return { fg = "fg1" }
    end,
    {
        require("user.plugins.heirline.file").NameBlock,
    },
    {
        require("user.plugins.heirline.lsp").Navic,
    },
}
