local M = {}
local utils = require("heirline.utils")

function M.mode_colors()
    return M.modes[vim.fn.mode(0)]
end

function M.set()
    --- :h nightfox-palette
    local nightfox_palette = require("nightfox.palette.nordfox").palette

    ---@class HeirlineNightfoxPalette
    ---@diagnostic disable: duplicate-doc-field
    ---@field black_base string nightfox_palette.black.base
    ---@field black_bright string nightfox_palette.black.bright
    ---@field black_dim string nightfox_palette.black.dim
    ---@field red_base string nightfox_palette.red.base
    ---@field red_bright string nightfox_palette.red.bright
    ---@field red_dim string nightfox_palette.red.dim
    ---@field green_base string nightfox_palette.green.base
    ---@field green_bright string nightfox_palette.green.bright
    ---@field green_dim string nightfox_palette.green.dim
    ---@field yellow_base string nightfox_palette.yellow.base
    ---@field yellow_bright string nightfox_palette.yellow.bright
    ---@field yellow_dim string nightfox_palette.yellow.dim
    ---@field blue_base string nightfox_palette.blue.base
    ---@field blue_bright string nightfox_palette.blue.bright
    ---@field blue_dim string nightfox_palette.blue.dim
    ---@field magenta_base string nightfox_palette.magenta.base
    ---@field magenta_bright string nightfox_palette.magenta.bright
    ---@field magenta_dim string nightfox_palette.magenta.dim
    ---@field cyan_base string nightfox_palette.cyan.base
    ---@field cyan_bright string nightfox_palette.cyan.bright
    ---@field cyan_dim string nightfox_palette.cyan.dim
    ---@field white_base string nightfox_palette.white.base
    ---@field white_bright string nightfox_palette.white.bright
    ---@field white_dim string nightfox_palette.white.dim
    ---@field orange_base string nightfox_palette.orange.base
    ---@field orange_bright string nightfox_palette.orange.bright
    ---@field orange_dim string nightfox_palette.orange.dim
    ---@field pink_base string nightfox_palette.pink.base
    ---@field pink_bright string nightfox_palette.pink.bright
    ---@field pink_dim string nightfox_palette.pink.dim
    ---@field comment string Comment color nightfox_palette.comment
    ---@field bg0 string Darker bg (status line and float)
    ---@field bg1 string Default bg
    ---@field bg2 string Lighter bg (colorcolumn folds)
    ---@field bg3 string Lighter bg (cursor line)
    ---@field bg4 string Lighter bg (Conceal, border fg)
    ---@field fg0 string Lighter fg
    ---@field fg1 string Default fg
    ---@field fg2 string Darker fg (status line)
    ---@field fg3 string Darker fg (line numbers, fold columns)
    ---@field sel0 string Popup bg, visual selection bg
    ---@field sel1 string Popup sel bg, search bg
    ---@field diag_warn string utils.get_highlight("DiagnosticWarn").fg
    ---@field diag_error string utils.get_highlight("DiagnosticError").fg
    ---@field diag_hint string utils.get_highlight("DiagnosticHint").fg
    ---@field diag_info string utils.get_highlight("DiagnosticInfo").fg
    ---@field diag_ok string utils.get_highlight("DiagnosticOk").fg
    ---@field git_del string utils.get_highlight("diffRemoved").fg
    ---@field git_add string utils.get_highlight("diffAdded").fg
    ---@field git_change string utils.get_highlight("diffChanged").fg
    ---@diagnostic enable: duplicate-doc-field
    M.colors = {
        diag_warn = utils.get_highlight("DiagnosticWarn").fg,
        diag_error = utils.get_highlight("DiagnosticError").fg,
        diag_hint = utils.get_highlight("DiagnosticHint").fg,
        diag_info = utils.get_highlight("DiagnosticInfo").fg,
        diag_ok = utils.get_highlight("DiagnosticOk").fg,
        git_del = utils.get_highlight("diffRemoved").fg,
        git_add = utils.get_highlight("diffAdded").fg,
        git_change = utils.get_highlight("diffChanged").fg,
    }

    for color_name, color in pairs(nightfox_palette) do
        if type(color) == "string" then
            M.colors[color_name] = color
        elseif type(color) == "table" then
            M.colors[color_name .. "_base"] = color["base"]
            M.colors[color_name .. "_bright"] = color["bright"]
            M.colors[color_name .. "_dim"] = color["dim"]
        end
    end

    M.modes = {
        n = { fg = M.colors.blue_bright, bg = M.colors.blue_dim, base = M.colors.blue_base },
        i = { fg = M.colors.green_bright, bg = M.colors.green_dim, base = M.colors.green_base },
        r = { fg = M.colors.red_bright, bg = M.colors.red_dim, base = M.colors.red_base },
        v = { fg = M.colors.magenta_bright, bg = M.colors.magenta_dim, base = M.colors.magenta_base },
        [""] = { fg = M.colors.magenta_bright, bg = M.colors.magenta_dim, base = M.colors.magenta_base },
        V = { fg = M.colors.magenta_bright, bg = M.colors.magenta_dim, base = M.colors.magenta_base },
        s = { fg = M.colors.cyan_bright, bg = M.colors.cyan_dim, base = M.colors.cyan_base },
        S = { fg = M.colors.cyan_bright, bg = M.colors.cyan_dim, base = M.colors.cyan_base },
        [""] = { fg = M.colors.cyan_bright, bg = M.colors.cyan_dim, base = M.colors.cyan_base },
        R = { fg = M.colors.red_bright, bg = M.colors.red_dim, base = M.colors.red_base },
        c = { fg = M.colors.orange_bright, bg = M.colors.orange_dim, base = M.colors.orange_base },
        ["!"] = { fg = M.colors.orange_bright, bg = M.colors.orange_dim, base = M.colors.orange_base },
        t = { fg = M.colors.white_bright, bg = M.colors.white_dim, base = M.colors.white_base },
    }

    require("heirline").load_colors(M.colors)
end

return M
