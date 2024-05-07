local M = {}

local wezterm = require("wezterm")
local act = wezterm.action

M.keys = {
    { key = [[f]], mods = [[SHIFT|ALT]], action = act.ToggleFullScreen },
    { key = [[b]], mods = [[SHIFT|ALT]], action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = [[v]], mods = [[SHIFT|ALT]], action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = [[t]], mods = [[SHIFT|ALT]], action = act.SpawnTab("CurrentPaneDomain") },
    { key = [[x]], mods = [[SHIFT|ALT]], action = act.CloseCurrentPane({ confirm = true }) },

    { key = [[>]], mods = [[SHIFT|CTRL]], action = act.IncreaseFontSize },
    { key = [[<]], mods = [[SHIFT|CTRL]], action = act.DecreaseFontSize },
    { key = [[?]], mods = [[SHIFT|CTRL]], action = act.ResetFontSize },

    { key = [[C]], mods = [[SHIFT|CTRL]], action = act.CopyTo("Clipboard") },
    { key = [[Insert]], mods = [[CTRL]], action = act.CopyTo("PrimarySelection") },
    { key = [[V]], mods = [[SHIFT|CTRL]], action = act.PasteFrom("Clipboard") },
    { key = [[Insert]], mods = [[SHIFT]], action = act.PasteFrom("PrimarySelection") },

    { key = [[F]], mods = [[SHIFT|CTRL]], action = act.Search("CurrentSelectionOrEmptyString") },
    { key = [[{]], mods = [[SHIFT|CTRL]], action = act.ActivateTabRelative(-1) },
    { key = [[}]], mods = [[SHIFT|CTRL]], action = act.ActivateTabRelative(1) },

    { key = [[X]], mods = [[SHIFT|CTRL]], action = act.ActivateCopyMode },
    { key = [[Z]], mods = [[SHIFT|CTRL]], action = act.TogglePaneZoomState },
    { key = [[P]], mods = [[SHIFT|CTRL]], action = act.ActivateCommandPalette },
    { key = [[L]], mods = [[SHIFT|CTRL]], action = act.ShowDebugOverlay },
    { key = [[N]], mods = [[SHIFT|CTRL]], action = act.SpawnWindow },
    { key = [[R]], mods = [[SHIFT|CTRL]], action = act.ReloadConfiguration },

    { key = [[PageUp]], mods = [[NONE]], action = act.ScrollByPage(-1) },
    { key = [[PageDown]], mods = [[NONE]], action = act.ScrollByPage(1) },

    { key = [[LeftArrow]], mods = [[SHIFT|CTRL]], action = act.ActivatePaneDirection("Left") },
    { key = [[RightArrow]], mods = [[SHIFT|CTRL]], action = act.ActivatePaneDirection("Right") },
    { key = [[UpArrow]], mods = [[SHIFT|CTRL]], action = act.ActivatePaneDirection("Up") },
    { key = [[DownArrow]], mods = [[SHIFT|CTRL]], action = act.ActivatePaneDirection("Down") },

    { key = [[LeftArrow]], mods = [[SHIFT|ALT|CTRL]], action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = [[RightArrow]], mods = [[SHIFT|ALT|CTRL]], action = act.AdjustPaneSize({ "Right", 1 }) },
    { key = [[UpArrow]], mods = [[SHIFT|ALT|CTRL]], action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = [[DownArrow]], mods = [[SHIFT|ALT|CTRL]], action = act.AdjustPaneSize({ "Down", 1 }) },

    {
        key = [[U]],
        mods = [[SHIFT|CTRL]],
        action = act.CharSelect({
            copy_on_select = true,
            copy_to = "ClipboardAndPrimarySelection",
            group = "NerdFonts",
        }),
    },
}

M.key_tables = {
    copy_mode = {
        { key = "Tab", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
        { key = "Tab", mods = "SHIFT", action = act.CopyMode("MoveBackwardWord") },
        { key = "Enter", mods = "NONE", action = act.CopyMode("MoveToStartOfNextLine") },
        { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
        { key = "Space", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },

        -- cursor move of emacs like
        { key = "b", mods = "CTRL", action = act.CopyMode("MoveLeft") },
        { key = "f", mods = "CTRL", action = act.CopyMode("MoveRight") },
        { key = "n", mods = "CTRL", action = act.CopyMode("MoveDown") },
        { key = "p", mods = "CTRL", action = act.CopyMode("MoveUp") },
        { key = "a", mods = "CTRL", action = act.CopyMode("MoveToStartOfLineContent") },
        { key = "e", mods = "CTRL", action = act.CopyMode("MoveToEndOfLineContent") },

        -- cursor move of vim like
        { key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
        { key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
        { key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
        { key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },

        { key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
        { key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
        { key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },

        { key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
        { key = "F", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
        { key = ",", mods = "NONE", action = act.CopyMode("JumpReverse") },
        { key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },

        { key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
        { key = "G", mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
        { key = "H", mods = "SHIFT", action = act.CopyMode("MoveToViewportTop") },
        { key = "L", mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },
        { key = "M", mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle") },

        { key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
        { key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
        { key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
        { key = "V", mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },

        { key = "q", mods = "NONE", action = act.CopyMode("Close") },
        {
            key = "y",
            mods = "NONE",
            action = act.Multiple({
                { CopyTo = "ClipboardAndPrimarySelection" },
                { CopyMode = "Close" },
            }),
        },
        { key = "PageUp", mods = "NONE", action = act.CopyMode("PageUp") },
        { key = "PageDown", mods = "NONE", action = act.CopyMode("PageDown") },
    },

    search_mode = {
        { key = "Enter", mods = "NONE", action = act.CopyMode("PriorMatch") },
        { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
        { key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
        { key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
        { key = "r", mods = "CTRL", action = act.CopyMode("CycleMatchType") },
        { key = "u", mods = "CTRL", action = act.CopyMode("ClearPattern") },
        { key = "PageUp", mods = "NONE", action = act.CopyMode("PriorMatchPage") },
        { key = "PageDown", mods = "NONE", action = act.CopyMode("NextMatchPage") },
    },
}
return M
