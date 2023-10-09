-- lua_add {{{
vim.opt.showmode = false
vim.opt.laststatus = 0
-- }}}

-- lua_source {{{
vim.opt.laststatus = 3
vim.opt.showtabline = 2

local active = {
    left = {
        { "mode", "paste", "skk_mode" },
        { "relativepath", "modified" },
    },
    right = {
        { "percent", "lineinfo" },
        { "fileformat", "fileencoding", "filetype" },
    },
}

local inactive = {
    left = {
        { "filename" },
    },
    right = {
        { "lineinfo" },
        { "percent" },
    },
}

local tabline = {
    left = {
        { "tabs" },
    },
    right = {
        { "git_branch" },
    },
}

local tab = {
    active = { "tabnum", "filename", "modified" },
    inactive = { "tabnum", "filename" },
}

local separator = {
    left = "",
    right = "",
}

local subseparator = {
    left = "",
    right = " ",
}

local component_function = {
    git_branch = [[vimrc#lightline_git_branch]],
    mode = [[vimrc#lightline_custom_mode]],
    skk_mode = [[lightline_skk#mode]],
}

vim.g.lightline = {
    colorscheme = "nordfox",
    active = active,
    inactive = inactive,
    tabline = tabline,
    tab = tab,
    separator = separator,
    subseparator = subseparator,
    component_function = component_function,
}

vim.api.nvim_create_user_command("LightlineUpdate", function()
    vim.fn["lightline#init"]()
    vim.fn["lightline#colorscheme"]()
    vim.fn["lightline#update"]()
end, {})
-- }}}
