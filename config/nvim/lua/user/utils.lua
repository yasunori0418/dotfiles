local M = {}
local autocmd = vim.api.nvim_create_autocmd

---全体共通設定のaugroup_id
---@return integer
M.vimrc_augroup = vim.api.nvim_create_augroup("vimrc", { clear = false })

---autocmd単発用
---自動でvimrcグループにセットする
---@param events table|string
---@param pattern table|string
---@param callback function|string
---@param group? string|integer
function M.autocmd_set(events, pattern, callback, group)
    group = group or M.vimrc_augroup
    autocmd(events, {
        group = group,
        pattern = pattern,
        callback = callback,
    })
end

---複数のautocmdを定義する
---@param autocmds { events: string|table, pattern: table|string, group: integer, callback: function|string }
function M.autocmds_set(autocmds)
    for _, item in pairs(autocmds) do
        autocmd(item.events, {
            group = item.group,
            pattern = item.pattern,
            callback = item.callback,
        })
    end
end

---複数のキーマップを定義する。
---@param keymaps { mode: string|string[], lhs: string, rhs: string|function, opts?: vim.keymap.set.Opts }[]
function M.keymaps_set(keymaps)
    for _, keymap in pairs(keymaps) do
        vim.keymap.set(keymap.mode, keymap.lhs, keymap.rhs, keymap.opts)
    end
end

---1行で書かれているAPI Tokenのファイルを読み込む
---@params path string -- Tokenファイルがあるパスを指定する。
---@return table { result: bool, token: string }
function M.load_token(path)
    local token = io.open(path, "r"):read("*l")
    if token ~= nil then
        return {
            result = true,
            token = token,
        }
    else
        return {
            result = false,
            token = "Can not read pat file.",
        }
    end
end

---現在のディレクトリからリポジトリルートのパスを取得する。
---gitconfigにて`git root`の定義が必須
---Gitリポジトリのルートパスまたは、
---Gitリポジトリでなければ、現在バッファーのディレクトリを返す
---@return string
function M.search_repo_root()
    local result = vim.fs.root(0, ".git")
    if result then
        return result
    end
    return tostring(vim.fn.expand("%:p:h"))
end

---luaのモジュール名前空間を解決する。
---@param base_module string
---@param ... string
---@return string
function M.resolve_module_namespace(base_module, ...)
    local result = base_module
    for _, module in ipairs({ ... }) do
        result = result .. "." .. module
    end
    return result
end


---配列から最後の要素だけを取得する。
---@generic T
---@param list T[]
---@return T
function M.last(list)
    return list[#list]
end

---get color code from hlGroup
---@param hl_name string
---@param type? "fg" | "bg"
---@param mode? "gui" | "cterm" | "term"
---@return string
function M.get_color_code(hl_name, type, mode)
    type = type or "fg"
    mode = mode or "gui"
    return vim.fn.synIDattr(
        vim.fn.synIDtrans(vim.fn.hlID(hl_name)),
        type,
        mode
    )
end

---table shallow copy
---@param table table
---@return table
function M.shallow_copy(table)
    local copy_table = {}
    for key, value in pairs(table) do
        copy_table[key] = value
    end
    return copy_table
end

return M
