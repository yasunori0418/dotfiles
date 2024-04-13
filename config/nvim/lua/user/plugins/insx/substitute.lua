local insx = require("insx")
local substitute = require("insx.recipe.substitute")

local M = {}

---@diagnostic disable:duplicate-doc-alias
---@alias AltercmdKeymaps { expand_keys: { space: boolean, cr: boolean } }

--- simulates altercmd by nvim-insx.
--- https://scrapbox.io/vim-jp/lexima.vim%E3%81%A7Better_vim-altercmd%E3%82%92%E5%86%8D%E7%8F%BE%E3%81%99%E3%82%8B
---@param original string
---@param altanative string
---@param keymaps AltercmdKeymaps
function M.altercmd(original, altanative, keymaps)
    if keymaps.expand_keys.space then
        insx.add(
            [[<Space>]],
            substitute({
                pattern = [[\(^\|'<,'>\)]] .. original .. [[\%#]],
                replace = [[\1]] .. altanative .. [[ \%#]],
            }),
            {
                mode = "c",
            }
        )
    end
    if keymaps.expand_keys.cr then
        insx.add(
            [[<CR>]],
            substitute({
                pattern = original .. [[\%#]],
                replace = altanative .. [[ \%# <CR>]],
            }),
            {
                mode = "c",
            }
        )
    end
end

return M
