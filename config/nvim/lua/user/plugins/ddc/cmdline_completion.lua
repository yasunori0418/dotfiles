local M = {}
local utils = require('user.utils')
local vimx = require('artemis')

local ddc = vimx.fn.ddc
local ddc_custom = vimx.fn.ddc.custom
local set_buffer = ddc_custom.set_buffer
local get_buffer = ddc_custom.get_buffer

local commandline_post = function()
  if vim.b.prev_buffer_config then
    set_buffer(vim.b.prev_buffer_config)
    vim.b.prev_buffer_config = nil
  end
end

M.commandline_pre = function()
  vim.b.prev_buffer_config = get_buffer()
  vim.api.nvim_create_autocmd("User", {
    group = utils.vimrc_augroup,
    pattern = "DDCCmdlineLeave",
    callback = function()
      commandline_post()
    end,
    once = true,
  })
  ddc.enable_cmdline_completion()
end


return M
