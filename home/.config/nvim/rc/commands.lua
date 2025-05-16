local command = vim.api.nvim_create_user_command
local ifx = require("user.utils").ifx

command("DppInstall", function()
    require("dpp").sync_ext_action("installer", "install")
end, {})

command("DppUpdate", function()
    require("dpp").async_ext_action("installer", "update")
end, {})

command("DppClearState", function()
    require("dpp").clear_state()
    vim.loader.reset()
    vim.cmd.quit({ bang = true })
end, {})

command("DDCFuzzyFilter", function(opts)
    require("user.plugins.ddc").change_filter(opts.bang, "fuzzy")
end, { bang = true })

command("DDCNormalFilter", function(opts)
    require("user.plugins.ddc").change_filter(opts.bang, "normal")
end, { bang = true })

command("DDCEchoFilter", function()
    require("user.plugins.ddc").change_filter(1, "")
end, {})

command("CurrentPath", function(opts)
    local path = vim.fn.fnamemodify(vim.fn.expand("%"), ifx(opts.bang, ":p", ""))
    vim.fn.setreg("+", path)
end, { bang = true })
