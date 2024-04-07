local insx = require("insx")
local substitute = require("insx.recipe.substitute")

local M = {}

---@diagnostic disable-next-line:duplicate-doc-alias
---@alias InsxMode 'c'|'i'|'n'

--- simulates altercmd by nvim-insx.
--- https://scrapbox.io/vim-jp/lexima.vim%E3%81%A7Better_vim-altercmd%E3%82%92%E5%86%8D%E7%8F%BE%E3%81%99%E3%82%8B
---@param original string
---@param altanative string
---@param expand_key string
---@param mode InsxMode
function M.altercmd(original, altanative, expand_key, mode)
    insx.add(
        expand_key,
        substitute({
            pattern = original .. [[\%#]],
            replace = altanative .. [[\%#]],
        }),
        {
            mode = mode,
        }
    )
end

return M
