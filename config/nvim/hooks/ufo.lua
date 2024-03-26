-- lua_source {{{
-- The following settings must be made in nvim-ufo.
vim.opt.foldmethod = "manual"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

local ufo = require("ufo")

local opt = { noremap = true, silent = true }
require("user.utils").keymaps_set({
    { -- zR
        mode = "n",
        lhs = [[zR]],
        rhs = ufo.openAllFolds,
        opts = opt,
    },
    { -- zM
        mode = "n",
        lhs = [[zM]],
        rhs = ufo.closeAllFolds,
        opts = opt,
    },
    { -- zr
        mode = "n",
        lhs = [[zr]],
        rhs = ufo.openFoldsExceptKinds,
        opts = opt,
    },
    { -- zm
        mode = "n",
        lhs = [[zm]],
        rhs = ufo.closeFoldsWith,
        opts = opt,
    },
    { -- <Tab> folded contents preview
        mode = "n",
        lhs = [[<Tab>]],
        rhs = function()
            local winid = ufo.peekFoldedLinesUnderCursor()
            if not winid then
                vim.api.nvim_feedkeys([[<Tab>]], "n", true)
            end
        end,
        opts = opt,
    },
})

local filetype_foldmethod = {
    toml = "", -- foldmethod = marker
    help = "", -- foldmethod = marker
}

local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (" 󰁂 %d "):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, "MoreMsg" })
    return newVirtText
end

ufo.setup({
    open_fold_hl_timeout = 150,
    close_fold_kinds_for_ft = { "imports", "comment" },
    preview = {
        win_config = {
            border = { "", "─", "", "", "", "─", "", "" },
            winhighlight = "Normal:Folded",
            winblend = 0,
        },
        mappings = {
            scrollU = "<C-u>",
            scrollD = "<C-d>",
            scrollE = "<C-e>",
            scrollY = "<C-y>",
            jumpTop = "[",
            jumpBot = "]",
            close = "q",
        },
    },
    enable_get_fold_virt_text = true,
    fold_virt_text_handler = handler,
    provider_selector = function(_, filetype, _) -- (bufnr, filetype, buftype)
        return filetype_foldmethod[filetype]
    end,
})

-- }}}
