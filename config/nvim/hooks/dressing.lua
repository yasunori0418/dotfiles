-- lua_source {{{
require("dressing").setup({
    input = {
        -- Set to false to disable the vim.ui.input implementation
        enabled = true,

        -- Default prompt string
        default_prompt = "Pattern",

        -- Trim trailing `:` from prompt
        trim_prompt = false,

        -- Can be 'left', 'right', or 'center'
        title_pos = "left",

        -- When true, <Esc> will close the modal
        insert_only = true,

        -- When true, input will start in insert mode.
        start_in_insert = true,

        -- These are passed to nvim_open_win
        border = "double",
        -- 'editor' and 'win' will default to being centered
        -- 'cursor' relative position
        relative = "editor",

        -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        prefer_width = 40,
        width = nil,
        -- min_width and max_width can be a list of mixed types.
        -- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
        max_width = { 140, 0.9 },
        min_width = { 20, 0.2 },

        buf_options = {},
        win_options = {
            -- Disable line wrapping
            wrap = false,
            -- Indicator for when text exceeds window
            list = true,
            listchars = "precedes:…,extends:…",
            -- Increase this for more context when text scrolls off the window
            sidescrolloff = 0,
        },

        -- Set to `false` to disable
        mappings = {
            n = {
                ["<Esc>"] = "Close",
                ["q"] = "Close",
                ["<CR>"] = "Confirm",
            },
            i = {
                ["<C-c>"] = "Close",
                ["<CR>"] = "Confirm",
                ["<Up>"] = "HistoryPrev",
                ["<Down>"] = "HistoryNext",
            },
        },

        override = function(conf)
            -- This is the config that will be passed to nvim_open_win.
            -- Change values here to customize the layout
            return conf
        end,

        -- see :help dressing_get_config
        get_config = nil,
    },
    select = {
        -- Set to false to disable the vim.ui.select implementation
        enabled = false,
    },
})
-- }}}
