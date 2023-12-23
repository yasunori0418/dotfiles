-- Neovide settings

-- Font and size settings when using GUI
vim.opt.guifont = [[HackGen\ Console\ NF:h14]]

local neovide_config = {
    padding_top = 0,
    padding_bottom = 0,
    padding_right = 0,
    padding_left = 0,
    refresh_rate = 60,
    no_idle = true,
    -- transparency = 0.8,
    scroll_animation_length = 0.1,
    cursor_animation_length = 0.1,
    cursor_trail_length = 0.3,
    cursor_trail_size = 0.3,
    cursor_antialiasing = true,
    cursor_vfx_mode = "railgun",
    hide_mouse_when_typing = true,
    underline_automatic_scaling = true,
    floating_blur_amount_x = 2.0,
    floating_blur_amount_y = 2.0,
    profiler = false,
}

for config_name, value in pairs(neovide_config) do
    vim.g["neovide_" .. config_name] = value
end
