-- lua_add {{{
local opt = { noremap = true }
if vim.uv.os_uname().sysname == "Darwin" then
    vim.g.previm_open_cmd = "open"
end
if vim.uv.os_uname().sysname == "Linux" then
    vim.g.previm_open_cmd = "google-chrome-stable"
end
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
