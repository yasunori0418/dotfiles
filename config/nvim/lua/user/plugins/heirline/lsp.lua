local M = {}
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

M.Names = {
    condition = conditions.lsp_attached,
    update = { "LspAttach", "LspDetach" },

    -- You can keep it simple,
    -- provider = " [LSP]",

    -- Or complicate things a bit and get the servers names
    provider = function()
        local names = {}
        for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
            table.insert(names, server.name)
        end
        return "  [" .. table.concat(names, " ") .. "] "
    end,
    hl = { fg = "green_base", bold = true },
}

M.Navic = {
    condition = function()
        return require("nvim-navic").is_available()
    end,
    static = {
        -- create a type highlight map
        type_hl = {
            File = "NavicIconsFile",
            Module = "NavicIconsModule",
            Namespace = "NavicIconsNamespace",
            Package = "NavicIconsPackage",
            Class = "NavicIconsClass",
            Method = "NavicIconsMethod",
            Property = "NavicIconsProperty",
            Field = "NavicIconsField",
            Constructor = "NavicIconsConstructor",
            Enum = "NavicIconsEnum",
            Interface = "NavicIconsInterface",
            Function = "NavicIconsFunction",
            Variable = "NavicIconsVariable",
            Constant = "NavicIconsConstant",
            String = "NavicIconsString",
            Number = "NavicIconsNumber",
            Boolean = "NavicIconsBoolean",
            Array = "NavicIconsArray",
            Object = "NavicIconsObject",
            Key = "NavicIconsKey",
            Null = "NavicIconsNull",
            EnumMember = "NavicIconsEnumMember",
            Struct = "NavicIconsStruct",
            Event = "NavicIconsEvent",
            Operator = "NavicIconsOperator",
            TypeParameter = "NavicIconsTypeParameter",
        },
        -- bit operation dark magic, see below...
        enc = function(line, col, winnr)
            return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr)
        end,
        -- line: 16 bit (65535); col: 10 bit (1023); winnr: 6 bit (63)
        dec = function(c)
            local line = bit.rshift(c, 16)
            local col = bit.band(bit.rshift(c, 6), 1023)
            local winnr = bit.band(c, 63)
            return line, col, winnr
        end,
    },
    init = function(self)
        local data = require("nvim-navic").get_data() or {}
        local children = {}
        -- create a child for each level
        for i, d in ipairs(data) do
            -- encode line and column numbers into a single integer
            local pos = self.enc(d.scope.start.line, d.scope.start.character, self.winnr)
            local child = {
                {
                    provider = d.icon,
                    hl = self.type_hl[d.type],
                },
                {
                    -- escape `%`s (elixir) and buggy default separators
                    provider = d.name:gsub("%%", "%%%%"):gsub("%s*->%s*", ""),
                    -- highlight icon only or location name as well
                    -- hl = self.type_hl[d.type],

                    on_click = {
                        -- pass the encoded position through minwid
                        minwid = pos,
                        callback = function(_, minwid)
                            -- decode
                            local line, col, winnr = self.dec(minwid)
                            vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), { line, col })
                        end,
                        name = "heirline_navic",
                    },
                },
            }
            -- add a separator only if needed
            if #data > 1 and i < #data then
                table.insert(child, {
                    provider = " > ",
                    hl = { fg = utils.get_highlight("NavicSeparator").fg },
                })
            end
            table.insert(children, child)
        end
        -- instantiate the new child, overwriting the previous one
        self.child = self:new(children, 1)
    end,
    -- evaluate the children containing navic components
    provider = function(self)
        return self.child:eval()
    end,
    hl = { fg = utils.get_highlight("NavicText").fg },
    update = "CursorMoved",
}

return M
