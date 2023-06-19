local M = {}
local utils = require('user.utils')
local vimx = require('artemis')
local ddc = vimx.fn.ddc
local ddc_custom = vimx.fn.ddc.custom

local patch_global = ddc_custom.patch_global
local get_global = ddc_custom.get_global
local set_buffer = ddc_custom.set_buffer
local get_buffer = ddc_custom.get_buffer

M.change_filter = function(bang, filter_name)
  if filter_name == 'normal' then
    patch_global('sourceOptions', {
      _ = {
        ignoreCase = true,
        matchers = { 'matcher_head', 'matcher_length' },
        sorters = { 'sorter_rank' },
        converters = { 'converter_remove_overlap' },
        },
      }
    )
  elseif filter_name == 'fuzzy' then
    patch_global('sourceOptions', {
      _ = {
        ignoreCase = true,
        matchers = { 'matcher_fuzzy' },
        sorters = { 'sorter_fuzzy' },
        converters = { 'converter_fuzzy' },
        },
      }
    )
  end
  if bang == 1 then
    vim.print(get_global().sourceOptions._)
  end
end

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
