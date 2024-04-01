-- luacheck: push no_max_comment_line_length
---@diagnostic disable-next-line:duplicate-doc-alias
---@alias WithOptions { filetype?: string|string[], in_comment?: boolean, in_string?: boolean, match: string, nomatch: string, priority: integer, undopoint?: boolean }
-- luacheck: pop

---@class InsxWithOptions
---@diagnostic disable:duplicate-doc-field
---@field public filetype? string|string[] # default nil
---@field public in_comment? boolean # default false
---@field public in_string? boolean # default false
---@field public match? string # default nil
---@field public nomatch? string # default nil
---@field public priority? integer # default nil
---@field public undopoint? boolean # default false
---@field public set_keys string[] # List of options passed when instantiating
---@field public new fun(options: WithOptions): InsxWithOptions
---@field public override_names fun(): string[]
---@field public overrides fun(self: InsxWithOptions): insx.Override[]
local InsxWithOptions = {}

---@param table table
---@return string[]
local function set_keys(table)
    local keys = {}
    for key, _ in pairs(table) do
        table.insert(keys, key)
    end
    return keys
end

---@param table table
---@return boolean
local function has_key(table, key)
    return table[key] ~= nil
end

---InsxWithOptions initializer
---@param options WithOptions
---@return InsxWithOptions
function InsxWithOptions.new(options)
    local obj = {
        filetype = options.filetype or "",
        in_comment = options.in_comment or false,
        in_string = options.in_string or false,
        match = options.match or "",
        nomatch = options.nomatch or "",
        priority = options.priority or 0,
        undopoint = options.undopoint or false,
        set_keys = set_keys(options),
    }
    return setmetatable(obj, { __index = InsxWithOptions })
end

---Get `insx with overrides` name list.
---@return string[]
function InsxWithOptions.override_names()
    return {
        "filetype",
        "in_comment",
        "in_string",
        "match",
        "nomatch",
        "priority",
        "undopoint",
    }
end

---Returns the result of the override option given to the rule to be set
---@param self InsxWithOptions
---@return table
function InsxWithOptions:overrides()
    local with = require("insx").with
    local result = {}
    for _, override in ipairs(self.override_names()) do
        local override_type = type(self[override])
        if override_type == "boolean" then
            if self[override] then
                table.insert(result, with[override](self[override]))
            end
        elseif override_type == "string" then
            if #self[override] == 0 then
                table.insert(result, with[override](self[override]))
            end
        elseif override_type == "number" then
            if self[override] == 0 then
                table.insert(result, with[override](self[override]))
            end
        end
    end
    return result
end

return InsxWithOptions
