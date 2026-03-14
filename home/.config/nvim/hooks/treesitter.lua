-- lua_source {{{
local treesitter = require("nvim-treesitter")
treesitter.setup({
    install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "treesitter"),
})

vim.treesitter.language.register("bash", { "sh", "zsh" })

vim.treesitter.language.register("sway", { "swayconfig" })

local function initialize()
    local uv = vim.uv
    local joinpath = vim.fs.joinpath
    local plugin_path = require("dpp").get("nvim-treesitter").path
    local treesitter_runtime = joinpath(vim.fn.stdpath("data"), "treesitter")
    local queries_path = joinpath(treesitter_runtime, "queries")
    local lstat = uv.fs_lstat(queries_path)
    if lstat == nil then
        vim.uv.fs_symlink(vim.fs.joinpath(plugin_path, "runtime", "queries"), queries_path)
    end
end
initialize()

vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        -- keep-sorted start
        "bash",
        "css",
        "diff",
        "dockerfile",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "gitrebase",
        "help",
        "html",
        "javascript",
        "json",
        "json5",
        "jsonc",
        "kdl",
        "kotlin",
        "lua",
        "make",
        "markdown",
        "nix",
        "sh",
        "swayconfig",
        "toml",
        "typescript",
        "vim",
        "xml",
        "yaml",
        "zsh",
        -- keep-sorted end
    },
    callback = function(ctx)
        -- syntax highlighting, provided by Neovim
        vim.treesitter.start()
        vim.bo[ctx.buf].syntax = "ON"
        -- folds, provided by Neovim
        -- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        -- indentation, provided by nvim-treesitter
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

-- }}}

-- lua_post_update {{{
vim.cmd([[TSUpdate]])
-- }}}
