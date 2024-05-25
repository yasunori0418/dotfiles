-- lua_add {{{
local opt = { noremap = false }
local utils = require("user.utils")
local start_filter_once = require("user.plugins.ddu").start_filter_once
utils.keymaps_set({
    -- ddu start prefixes
    { mode = "n", lhs = [[ d]], rhs = [[<Plug>(ddu-ff)]], opts = opt },
    { mode = "n", lhs = [[ f]], rhs = [[<Plug>(ddu-filer)]], opts = opt },

    -- ddu-ui-ff starter
    { -- current
        mode = "n",
        lhs = [[<Plug>(ddu-ff)a]],
        rhs = function()
            start_filter_once()
            vim.fn["ddu#start"]({
                name = "current",
                sourceOptions = {
                    file_rec = {
                        path = utils.search_repo_root(),
                    },
                },
            })
        end,
        opts = opt,
    },
    { -- dotfiles
        mode = "n",
        lhs = [[<Plug>(ddu-ff)d]],
        rhs = function()
            start_filter_once()
            vim.fn["ddu#start"]({ name = "dotfiles" })
        end,
        opts = opt,
    },
    { -- help
        mode = "n",
        lhs = [[<Plug>(ddu-ff)h]],
        rhs = function()
            start_filter_once()
            vim.fn["ddu#start"]({ name = "help" })
        end,
        opts = opt,
    },
    { -- buffer
        mode = "n",
        lhs = [[<Plug>(ddu-ff)b]],
        rhs = function()
            vim.fn["ddu#start"]({ name = "buffer" })
        end,
        opts = opt,
    },
    { -- plugin-list
        mode = "n",
        lhs = [[<Plug>(ddu-ff)P]],
        rhs = function()
            start_filter_once()
            vim.fn["ddu#start"]({ name = "plugin-list" })
        end,
        opts = opt,
    },
    { -- register
        mode = "n",
        lhs = [[<Plug>(ddu-ff)r]],
        rhs = function()
            vim.fn["ddu#start"]({ name = "register" })
        end,
        opts = opt,
    },
    { -- ripgrep live grep
        mode = "n",
        lhs = [[<Plug>(ddu-ff)s]],
        rhs = function()
            start_filter_once()
            vim.fn["ddu#start"]({ name = "ripgrep" })
        end,
        opts = opt,
    },
    { -- mrr most recent repositories
        mode = "n",
        lhs = [[<Plug>(ddu-ff)m]],
        rhs = function()
            vim.fn["ddu#start"]({ name = "mrr" })
        end,
        opts = opt,
    },
    { -- mru most recent used files
        mode = "n",
        lhs = [[<Plug>(ddu-ff)n]],
        rhs = function()
            vim.fn["ddu#start"]({ name = "mru" })
        end,
        opts = opt,
    },
    { -- search_line
        mode = "n",
        lhs = [[<Plug>(ddu-ff)/]],
        rhs = function()
            start_filter_once()
            vim.fn["ddu#start"]({ name = "search_line" })
        end,
        opts = opt,
    },
    { -- hightlight
        mode = "n",
        lhs = [[<Plug>(ddu-ff)C]],
        rhs = function()
            start_filter_once()
            vim.fn["ddu#start"]({ name = "highlight" })
        end,
        opts = opt,
    },
    {
        mode = "n",
        lhs = [[<Plug>(ddu-ff)N]],
        rhs = function()
            vim.fn["ddu#start"]({ name = "notify" })
        end,
    },

    -- git control by ddu
    { -- git:status
        mode = "n",
        lhs = [[<Plug>(git)s]],
        rhs = function()
            vim.fn["ddu#start"]({ name = "git:status" })
        end,
        opts = opt,
    },
    { -- git:log
        mode = "n",
        lhs = [[<Plug>(git)l]],
        rhs = function()
            vim.fn["ddu#start"]({ name = "git:log" })
        end,
        opts = opt,
    },
    { -- git_branch
        mode = "n",
        lhs = [[<Plug>(git)b]],
        rhs = function()
            vim.fn["ddu#start"]({ name = "git:branch" })
        end,
        opts = opt,
    },
    { -- ghq
        mode = "n",
        lhs = [[<Plug>(git)q]],
        rhs = function()
            vim.fn["ddu#start"]({ name = "ghq" })
        end,
        opts = opt,
    },
    { -- gh_project_list
        mode = "n",
        lhs = [[<Plug>(ddu-ff)<]],
        rhs = function()
            vim.fn["ddu#start"]({ name = "gh:project_list" })
        end,
        opts = opt,
    },
    { -- gh_project
        mode = "n",
        lhs = [[<Plug>(ddu-ff),]],
        rhs = function()
            vim.fn["ddu#start"]({ name = "gh:project" })
        end,
        opts = opt,
    },

    -- ddu-ui-filer starter
    { -- project_root-filer
        mode = "n",
        lhs = [[<Plug>(ddu-filer)a]],
        rhs = function()
            vim.fn["ddu#start"]({
                name = "current-filer",
                sourceOptions = {
                    file = {
                        path = utils.search_repo_root(),
                    },
                },
            })
        end,
        opts = opt,
    },
    { -- current-filer open filer at current buffer directory
        mode = "n",
        lhs = [[<Plug>(ddu-filer)f]],
        rhs = function()
            vim.fn["ddu#start"]({
                name = "current-filer",
                sourceOptions = {
                    file = {
                        path = vim.fn.expand("%:p:h"),
                    },
                },
            })
        end,
        opts = opt,
    },
    { -- dotfiles-filer
        mode = "n",
        lhs = [[<Plug>(ddu-filer)d]],
        rhs = function()
            vim.fn["ddu#start"]({ name = "dotfiles-filer" })
        end,
        opts = opt,
    },
    { -- home-filer
        mode = "n",
        lhs = [[<Plug>(ddu-filer)~]],
        rhs = function()
            vim.fn["ddu#start"]({ name = "home-filer" })
        end,
        opts = opt,
    },
})

-- }}}

-- lua_source {{{
local ddu_hooks = vim.fs.joinpath(vim.g.hooks_dir, "ddu")
vim.fn["ddu#custom#load_config"](
    -- $HOOKS_DIR/ddu/config.ts
    vim.fs.joinpath(ddu_hooks, "config.ts")
)
-- }}}

-- lua_post_update {{{
vim.fn["ddu#set_static_import_path"]()
-- }}}
