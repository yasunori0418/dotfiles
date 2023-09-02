local ddc = {}

ddc.cmdline_completion = require("user.plugins.ddc.cmdline_completion").commandline_pre

ddc.change_filter = require("user.plugins.ddc.other").change_filter

return ddc
