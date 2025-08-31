local command = vim.api.nvim_create_user_command
local utils = require("user.utils")
local ifx = utils.ifx

command("DppInstall", function()
    require("dpp").sync_ext_action("installer", "install")
end, {})

command("DppUpdate", function()
    require("dpp").async_ext_action("installer", "update")
end, {})

command("DppUpdateAndClose", function()
    require("dpp").async_ext_action("installer", "update")
    utils.autocmd_set("User", "Dpp:extActionPost:installer:update", function()
        utils.autocmd_set("User", "Dpp:makeStatePost", function()
            vim.cmd.quitall({ bang = true })
        end)
    end)
end, {})

command("DppClearState", function()
    require("dpp").clear_state()
    vim.loader.reset()
    vim.cmd.quit({ bang = true })
end, {})

command("DppDenoCache", function()
    require("dpp").async_ext_action("installer", "denoCache")
    utils.autocmd_set("User", "Dpp:extActionPost:installer:denoCache", function()
        vim.notify("DppDenoCache Done!", vim.log.levels.INFO)
    end)
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
