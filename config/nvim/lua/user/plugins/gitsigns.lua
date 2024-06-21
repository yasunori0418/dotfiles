local M = {}

local gitsigns = require("gitsigns")
local utils = require("user.utils")

---current_line_blame_formatter
---@param name string
---@param blame_info Gitsigns.BlameInfoPublic
---@return {[1]:string,[2]:"GitSignsCurrentLineBlame"}[]
function M.blame_line_formatter(name, blame_info)
    if name == blame_info.author then
        return { { [1] = "", [2] = "GitSignsCurrentLineBlame" } }
    end
    local text = blame_info.author .. ":" .. blame_info.abbrev_sha .. " - " .. blame_info.summary
    return { { [1] = text, [2] = "GitSignsCurrentLineBlame" } }
end

---set keymaps by on_attach
---@param bufnr integer
function M.keymaps_set(bufnr)
    ---@type vim.keymap.set.Opts
    local opts = { nnoremap = true, buffer = bufnr }

    ---@type Gitsigns.NavOpts
    local nav_opts = {
        wrap = true,
        navigation_message = true,
        foldopen = true,
        preview = true,
        greedy = true,
        target = "all",
        count = vim.v.count1,
    }

    utils.keymaps_set({
        {
            mode = { "n", "x" },
            lhs = [[gs]],
            rhs = [[<Plug>(gitsigns)]],
            opts = { noremap = false, buffer = bufnr },
        },
        {
            mode = { "n" },
            lhs = "]c",
            rhs = function()
                if vim.wo.diff then
                    vim.cmd.normal({ "]c", bang = true })
                else
                    gitsigns.nav_hunk("next", nav_opts)
                end
            end,
            opts = opts,
        },
        {
            mode = { "n" },
            lhs = "[c",
            rhs = function()
                if vim.wo.diff then
                    vim.cmd.normal({ "[c", bang = true })
                else
                    gitsigns.nav_hunk("prev", nav_opts)
                end
            end,
            opts = opts,
        },
        {
            mode = { "n" },
            lhs = [[<Plug>(gitsigns)s]],
            rhs = function()
                gitsigns.stage_hunk()
            end,
            opts = opts,
        },
        {
            mode = { "n" },
            lhs = [[<Plug>(gitsigns)r]],
            rhs = function()
                gitsigns.reset_hunk()
            end,
            opts = opts,
        },
        {
            mode = { "x" },
            lhs = [[<Plug>(gitsigns)s]],
            rhs = function()
                gitsigns.stage_hunk({
                    vim.fn.line("."),
                    vim.fn.line("v"),
                })
            end,
            opts = opts,
        },
        {
            mode = { "x" },
            lhs = [[<Plug>(gitsigns)r]],
            rhs = function()
                gitsigns.reset_hunk({
                    vim.fn.line("."),
                    vim.fn.line("v"),
                })
            end,
            opts = opts,
        },
        {
            mode = { "n" },
            lhs = [[<Plug>(gitsigns)S]],
            rhs = function()
                gitsigns.stage_buffer()
            end,
            opts = opts,
        },
        {
            mode = { "n" },
            lhs = [[<Plug>(gitsigns)R]],
            rhs = function()
                gitsigns.reset_buffer()
            end,
            opts = opts,
        },
        {
            mode = { "n" },
            lhs = [[<Plug>(gitsigns)u]],
            rhs = function()
                gitsigns.undo_stage_hunk()
            end,
            opts = opts,
        },
        {
            mode = { "n" },
            lhs = [[<Plug>(gitsigns)p]],
            rhs = function()
                gitsigns.preview_hunk()
            end,
            opts = opts,
        },
        {
            mode = { "n" },
            lhs = [[<Plug>(gitsigns)b]],
            rhs = function()
                gitsigns.blame_line({ full = true })
            end,
            opts = opts,
        },
        {
            mode = { "n" },
            lhs = [[<Plug>(gitsigns)d]],
            rhs = function()
                gitsigns.diffthis()
            end,
            opts = opts,
        },
        {
            mode = {"o", "x"},
            lhs = [[is]],
            rhs = function()
                gitsigns.select_hunk()
            end,
            opts = opts,
        }
    })
end

return M
