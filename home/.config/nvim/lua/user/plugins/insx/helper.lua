local M = {
    with = {},
}

local insx = require("insx")
local esc = require("insx.helper.regex").esc
local with = insx.with

---insx.add with override
---@param recipe_source_like insx.RecipeSourceLike
---@param mode? insx.Mode[]
---@return fun(key: string, overrides?: insx.Override[])
function M.insx_override_add(recipe_source_like, mode)
    mode = mode or { "i", "c" }
    return function(key, overrides)
        overrides = overrides or {}
        insx.add(key, with(recipe_source_like, overrides), { mode = mode })
    end
end

---invert insx.with.filetype
---@param filetypes string|string[]
---@return insx.Override
function M.with.not_filetype(filetypes)
    filetypes = require("insx.kit").to_array(filetypes) --[=[@as string[]]]=]
    return {
        ---@param enabled insx.Enabled
        ---@param ctx insx.Context
        enabled = function(enabled, ctx)
            local res = not vim.tbl_contains(filetypes, ctx.filetype)
            vim.print(res)
            return res and enabled(ctx)
        end,
    }
end

---insx fast_break
---@param key string
---@param open string
---@param close string
---@param override? insx.Override[]
function M.fast_break(key, open, close, override)
    M.insx_override_add(
        require("insx.recipe.fast_break")({
            open_pat = esc(open),
            close_pat = esc(close),
            arguments = true,
            html_attrs = true,
            html_tags = true,
        }),
        { "i" }
    )(key, override)
end

---insx fast_wrap
---@param key string
---@param close string
---@param overrides? insx.Override[]
function M.fast_wrap(key, close, overrides)
    M.insx_override_add(
        require("insx.recipe.fast_wrap")({
            close = close,
        }),
        { "i" }
    )(key, overrides)
end

function M.altercmd(original, altanative)
    ---@type insx.recipe.substitute.Option
    local options = {
        pattern = [[\v(^|'\<,'\>)]] .. original .. [[\%#]],
        replace = [[\1]] .. altanative .. [[ \%#]],
    }
    local recipe = require("insx.recipe.substitute")(options)
    ---@param ctx insx.Context
    recipe.enabled = function(ctx)
        return vim.fn.getcmdtype() == ":" and ctx.match(options.pattern)
    end
    M.insx_override_add(recipe, { "c" })("<Space>")
end

---lambdalisue/vim-kensaku-search
---@return insx.RecipeSource
function M.kensaku_search_expand()
    return {
        enabled = function()
            local current_cmd_type = vim.fn.getcmdtype()
            return current_cmd_type == "/" or current_cmd_type == "?"
        end,
        ---@param ctx insx.Context
        action = function(ctx)
            ctx.send(vim.fn["kensaku_search#replace"]())
        end,
    }
end

return M
