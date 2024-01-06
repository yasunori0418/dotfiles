local command = vim.api.nvim_create_user_command
local ddc_change_filter = require("user.plugins.ddc").change_filter
local dpp = require("dpp")

command("DppInstall", function()
    dpp.sync_ext_action("installer", "install")
end, {})

command("DppInstallQuit", function()
    vim.api.nvim_create_autocmd("User", {
        pattern = "Dpp:makeStatePost",
        callback = function()
            vim.notify("dpp make_state() is done", vim.log.levels.INFO)
            vim.cmd.quit()
        end,
    })
    dpp.sync_ext_action("installer", "install")
end, {})

command("DppUpdate", function()
    dpp.async_ext_action("installer", "update")
end, {})

command("DppClear", function()
    dpp.clear_state()
    vim.loader.reset()
    vim.cmd.quit()
end, {})

command("DDCFuzzyFilter", function(opts)
    ddc_change_filter(opts.bang, "fuzzy")
end, { bang = true })

command("DDCNormalFilter", function(opts)
    ddc_change_filter(opts.bang, "normal")
end, { bang = true })

command("DDCEchoFilter", function()
    ddc_change_filter(1, "")
end, {})
