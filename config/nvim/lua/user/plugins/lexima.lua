local M = {}

local add = vim.fn["lexima#add_rule"]

-- simulates altercmd by lexima
-- https://scrapbox.io/vim-jp/lexima.vim%E3%81%A7Better_vim-altercmd%E3%82%92%E5%86%8D%E7%8F%BE%E3%81%99%E3%82%8B
function M.altercmd(original, altanative)
    add({ -- <SPACE>
        mode = ":",
        at = [[^\('<,'>\)\?]] .. original .. [[\%#$]],
        char = "<Space>",
        input = "<C-w>" .. altanative .. "<Space>",
    })

    add({ -- <CR>
        mode = ":",
        at = [[^\('<,'>\)\?]] .. original .. [[\%#$]],
        char = "<CR>",
        input = "<C-w>" .. altanative .. "<CR>",
    })
end

return M
