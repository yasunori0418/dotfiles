-- lua_source {{{
require("claude-code").setup({
    -- Terminal window settings
    window = {
        -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
        split_ratio = 0.3,
        -- Position of the window: "botright", "topleft", "vertical", "rightbelow vsplit", etc.
        position = "botright",
        -- Whether to enter insert mode when opening Claude Code
        enter_insert = true,
        -- Hide line numbers in the terminal window
        hide_numbers = true,
        -- Hide the sign column in the terminal window
        hide_signcolumn = true,
    },
    -- File refresh settings
    refresh = {
        -- Enable file change detection
        enable = true,
        -- updatetime when Claude Code is active (milliseconds)
        updatetime = 100,
        -- How often to check for file changes (milliseconds)
        timer_interval = 1000,
        -- Show notification when files are reloaded
        show_notifications = true,
    },
    -- Git project settings
    git = {
        -- Set CWD to git root when opening Claude Code (if in git project)
        use_git_root = true,
    },
    -- Shell-specific settings
    shell = {
        -- Command separator used in shell commands
        separator = "&&",
        -- Command to push directory onto stack (e.g., 'pushd' for bash/zsh, 'enter' for nushell)
        pushd_cmd = "pushd",
        -- Command to pop directory from stack (e.g., 'popd' for bash/zsh, 'exit' for nushell)
        popd_cmd = "popd",
    },
    -- Command settings
    -- Command used to launch Claude Code
    command = "claude",
    -- Command variants
    command_variants = {
        -- Conversation management
        -- Resume the most recent conversation
        continue = "--continue",
        -- Display an interactive conversation picker
        resume = "--resume",

        -- Output options
        -- Enable verbose logging with full turn-by-turn output
        verbose = "--verbose",
    },
    -- Keymaps
    keymaps = {
        toggle = {
            -- Normal mode keymap for toggling Claude Code, false to disable
            normal = "<C-,>",
            -- Terminal mode keymap for toggling Claude Code, false to disable
            terminal = "<C-,>",
            variants = {
                -- Normal mode keymap for Claude Code with continue flag
                continue = "<leader>cC",
                -- Normal mode keymap for Claude Code with verbose flag
                verbose = "<leader>cV",
            },
        },
        -- Enable window navigation keymaps (<C-h/j/k/l>)
        window_navigation = false,
        -- Enable scrolling keymaps (<C-f/b>) for page up/down
        scrolling = true,
    },
})
-- }}}
