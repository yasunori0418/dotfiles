-- lua_add {{{
require("nightfox").setup({
    options = {
        -- Compiled file's destination location
        compile_path = vim.fn.stdpath("cache") .. "/nightfox",
        compile_file_suffix = "_compiled", -- Compiled file suffix
        transparent = false, -- Disable setting background
        terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*)
        dim_inactive = false, -- Non focused panes set to alternative background
        module_default = true,
        styles = { -- Style to be applied to different syntax groups
            comments = "italic",
            conditionals = "NONE",
            constants = "NONE",
            functions = "bold",
            keywords = "NONE",
            numbers = "NONE",
            operators = "NONE",
            strings = "NONE",
            types = "NONE",
            variables = "NONE",
        },
        inverse = { -- Inverse highlight for different types
            match_paren = false,
            visual = true,
            search = false,
        },
        modules = { -- List of various plugins and additional options
            alpha = false,
            aerial = false,
            barbar = false,
            cmp = false,
            coc = false,
            ["dap-ui"] = false,
            dashboard = false,
            diagnostic = {
                enable = true,
                background = true,
            },
            fern = false,
            fidget = true,
            gitgutter = false,
            gitsigns = true,
            glyph_palette = false,
            hop = false,
            illuminate = true,
            indent_blanklines = true,
            leap = false,
            lightspeed = false,
            lsp_saga = false,
            lsp_trouble = false,
            mini = false,
            modes = false,
            native_lsp = {
                enable = true,
                background = true,
            },
            navic = true,
            neogit = false,
            neotest = false,
            neotree = false,
            notify = true,
            nvimtree = false,
            pounce = false,
            signify = false,
            sneak = false,
            symbol_outline = false,
            telescope = false,
            treesitter = true,
            tsrainbow = false,
            tsrainbow2 = false,
            whichkey = false,
        },
    },
})

-- vim.g.nightfox_name = "nightfox"
-- vim.g.nightfox_name = "dayfox"
-- vim.g.nightfox_name = "dawnfox"
-- vim.g.nightfox_name = "duskfox"
vim.g.nightfox_name = "nordfox"
-- vim.g.nightfox_name = "terafox"
-- vim.g.nightfox_name = "carbonfox"
vim.cmd.colorscheme(vim.g.nightfox_name)
-- }}}
