-- lua_add {{{
local opt = { noremap = true }
vim.g.previm_open_cmd = "google-chrome-stable"
require("user.utils").keymaps_set({
    { mode = "n", lhs = [[ p]], rhs = [[<Plug>(previm)]], opts = {} },
    {
        mode = "n",
        lhs = [[<Plug>(previm)o]],
        rhs = function()
            vim.cmd.PrevimOpen()
        end,
        opts = opt,
    },
    {
        mode = "n",
        lhs = [[<Plug>(previm)r]],
        rhs = function()
            vim.fn["previm#refresh"]()
        end,
        opts = opt,
    },
})
-- }}}

-- lua_source {{{
vim.g.previm_enable_realtime = true
vim.g.previm_disable_default_css = true
vim.g.previm_custom_css_path = vim.fs.joinpath(vim.g.hooks_dir, "previm", "previm_markdown.css")
vim.g.previm_plantuml_imageprefix = "http://localhost:58080/png/"
-- }}}
