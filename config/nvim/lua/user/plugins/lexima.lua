local M = {}

local add = vim.fn["lexima#add_rule"]

---複数のruleを登録する
---@param rules table[] # 複数のleximaのルール
---@param filetype? string # 特定のfiletype向けの設定時にruleへfiletypeを指定する
function M.add_rules(rules, filetype)
    filetype = filetype or nil
    for _, rule in ipairs(rules) do
        if filetype then
            rule.filetype = filetype
        end
        add(rule)
    end
end

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
