local M = {}
local vimx = require('artemis')
local ddc_custom = vimx.fn.ddc.custom

local patch_global = ddc_custom.patch_global
local get_global = ddc_custom.get_global

function M.change_filter(bang, filter_name)
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

return M
