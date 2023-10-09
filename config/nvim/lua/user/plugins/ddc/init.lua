local M = {}

M.cmdline_completion = require("user.plugins.ddc.cmdline_completion").commandline_pre

M.change_filter = require("user.plugins.ddc.utils").change_filter

return M
