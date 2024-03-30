---@class InsxWithOptions
---@diagnostic disable:duplicate-doc-field
---@field public filetype? string|string[] # default nil
---@field public in_comment? boolean # default false
---@field public in_string? boolean # default false
---@field public match? string # default nil
---@field public nomatch? string # default nil
---@field public priority? integer # default nil
---@field public undopoint? boolean # default false
---@field public new fun(options: table<string, string>): InsxWithOptions
---@field public overrides fun(self: InsxWithOptions): insx.Override[]
local InsxWithOptions = {}

---InsxWithOptions initializer
---@param options table<string, string>
---@return InsxWithOptions
function InsxWithOptions.new(options)
    local obj = {
        filetype = options.filetype or nil,
        in_comment = options.in_comment or false,
        in_string = options.in_string or false,
        match = options.match or nil,
        nomatch = options.nomatch or nil,
        priority = options.priority or nil,
        undopoint = options.undopoint or false,
    }
    return setmetatable(obj, { __index = InsxWithOptions })
end

---Returns the result of the override option given to the rule to be set
---@param self InsxWithOptions
---@return table
function InsxWithOptions:overrides()
    local with = require("insx").with
    local result = {}
    for _, override in ipairs({
        "filetype",
        "in_comment",
        "in_string",
        "match",
        "nomatch",
        "priority",
        "undopoint",
    }) do
        if self[override] then
            table.insert(result, with[override](self[override]))
        end
    end
    return result
end

return InsxWithOptions
