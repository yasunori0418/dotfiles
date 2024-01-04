local command = vim.api.nvim_create_user_command
local ddc_change_filter = require("user.plugins.ddc").change_filter

command("DDCFuzzyFilter", function(opts)
    ddc_change_filter(opts.bang, "fuzzy")
end, { bang = true })

command("DDCNormalFilter", function(opts)
    ddc_change_filter(opts.bang, "normal")
end, { bang = true })

command("DDCEchoFilter", function()
    ddc_change_filter(1, "")
end, {})
