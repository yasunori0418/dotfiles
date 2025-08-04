-- lua_source {{{
local utils = require("user.utils")

require("nvim-treesitter-textobjects").setup({
    select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        -- You can choose the select mode (default is charwise 'v')
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * method: eg 'v' or 'o'
        -- and should return the mode ('v', 'V', or '<c-v>') or a table
        -- mapping query_strings to modes.
        selection_modes = {
            ["@function.outer"] = "v",
            ["@function.inner"] = "v",
            ["@class.outer"] = "v",
            ["@class.inner"] = "v",
            ["@parameter.outer"] = "v",
            ["@parameter.inner"] = "v",
            ["@loop.outer"] = "v",
            ["@conditional.outer"] = "v",
        },
        -- If you set this to `true` (default is `false`) then any textobject is
        -- extended to include preceding or succeeding whitespace. Succeeding
        -- whitespace has priority in order to act similarly to eg the built-in
        -- `ap`.
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * selection_mode: eg 'v'
        -- and should return true of false
        include_surrounding_whitespace = false,
    },
    move = {
        -- whether to set jumps in the jumplist
        set_jumps = true,
    },
})

local opts = { noremap = true, silent = true } --[[@as vim.keymap.set.Opts]]

---@param query_string string
local select_textobject = function(query_string)
    return require("nvim-treesitter-textobjects.select").select_textobject(query_string, "textobjects")
end

---@param query_string string
local swap_next = function(query_string)
    return require("nvim-treesitter-textobjects.swap").swap_next(query_string, "textobjects")
end

---@param query_string string
local swap_prev = function(query_string)
    return require("nvim-treesitter-textobjects.swap").swap_previous(query_string, "textobjects")
end

---@param query_string string|string[]
local goto_next_start = function(query_string)
    return require("nvim-treesitter-textobjects.move").goto_next_start(query_string, "textobjects")
end

---@param query_string string|string[]
local goto_next_end = function(query_string)
    return require("nvim-treesitter-textobjects.move").goto_next_end(query_string, "textobjects")
end

---@param query_string string|string[]
local goto_prev_start = function(query_string)
    return require("nvim-treesitter-textobjects.move").goto_previous_start(query_string, "textobjects")
end

---@param query_string string|string[]
local goto_prev_end = function(query_string)
    return require("nvim-treesitter-textobjects.move").goto_previous_end(query_string, "textobjects")
end

utils.keymaps_set({
    -- textobjects
    {
        mode = { "x", "o" },
        lhs = [[af]],
        rhs = function()
            select_textobject("@function.outer")
        end,
        opts = opts,
    },
    {
        mode = { "x", "o" },
        lhs = [[if]],
        rhs = function()
            select_textobject("@function.inner")
        end,
        opts = opts,
    },
    {
        mode = { "x", "o" },
        lhs = [[ac]],
        rhs = function()
            select_textobject("@class.outer")
        end,
        opts = opts,
    },
    {
        mode = { "x", "o" },
        lhs = [[ic]],
        rhs = function()
            select_textobject("@class.inner")
        end,
        opts = opts,
    },

    -- swap parameter
    {
        mode = { "n" },
        lhs = [=[]a]=],
        rhs = function()
            swap_next("@parameter.inner")
        end,
        opts = opts,
    },
    {
        mode = { "n" },
        lhs = [=[[a]=],
        rhs = function()
            swap_prev("@parameter.outer")
        end,
        opts = opts,
    },

    -- move function and class
    {
        mode = { "n", "x", "o" },
        lhs = [=[]f]=],
        rhs = function()
            goto_next_start({ "@function.outer", "@class.outer" })
        end,
        opts = opts,
    },
    {
        mode = { "n", "x", "o" },
        lhs = [=[]F]=],
        rhs = function()
            goto_next_end({ "@function.outer", "@class.outer" })
        end,
        opts = opts,
    },
    {
        mode = { "n", "x", "o" },
        lhs = [=[[f]=],
        rhs = function()
            goto_prev_start({ "@function.outer", "@class.outer" })
        end,
        opts = opts,
    },
    {
        mode = { "n", "x", "o" },
        lhs = [=[[F]=],
        rhs = function()
            goto_prev_end({ "@function.outer", "@class.outer" })
        end,
        opts = opts,
    },

    -- move loop and conditional
    {
        mode = { "n", "x", "o" },
        lhs = [=[]m]=],
        rhs = function()
            goto_next_start({ "@loop.outer", "@conditional.outer" })
        end,
        opts = opts,
    },
    {
        mode = { "n", "x", "o" },
        lhs = [=[]M]=],
        rhs = function()
            goto_next_end({ "@loop.outer", "@conditional.outer" })
        end,
        opts = opts,
    },
    {
        mode = { "n", "x", "o" },
        lhs = [=[[m]=],
        rhs = function()
            goto_prev_start({ "@loop.outer", "@conditional.outer" })
        end,
        opts = opts,
    },
    {
        mode = { "n", "x", "o" },
        lhs = [=[[M]=],
        rhs = function()
            goto_prev_end({ "@loop.outer", "@conditional.outer" })
        end,
        opts = opts,
    },
})

-- }}}
