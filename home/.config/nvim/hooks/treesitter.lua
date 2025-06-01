-- lua_source {{{
---@diagnostic disable-next-line missing-fields
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash",
        "diff",
        "dockerfile",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "lua",
        "luadoc",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
        "php",
        "html",
    },
    ignore_install = {},
    -- Install parsers synchronously (only applied to `ensure_installed`)
    -- Settings for load reduction.
    sync_install = true,
    -- Automatically install missing parsers when entering buffer
    auto_install = true,
    highlight = {
        enable = true,
        disable = function(lang, buf)
            local languages = {
                -- "vimdoc",
            }
            if vim.iter(languages):find(lang) then
                return true
            end
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
    },
    indent = {
        enable = false,
    },
    yati = {
        enable = true,
        default_lazy = true,
        default_fallback = "auto",
    },
})

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

---@diagnostic disable-next-line inject-field
parser_config.blade = {
    install_info = {
        url = "https://github.com/EmranMR/tree-sitter-blade",
        files = { "src/parser.c" },
        branch = "main",
    },
    filetype = "blade",
}

---@diagnostic disable-next-line inject-field
parser_config.kanata = {
    install_info = {
        url = "https://github.com/postsolar/tree-sitter-kanata",
        files = { "src/parser.c" },
        branch = "master",
    },
    filetype = "kdb",
}

vim.filetype.add({
    pattern = {
        [".*%.blade%.php"] = "blade",
        [".*%.kdb"] = "kdb",
    },
})

-- }}}

-- lua_post_update {{{
vim.opt.more = false
vim.cmd([[TSUpdate]])
vim.opt.more = true
-- }}}
