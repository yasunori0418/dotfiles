local M = {}
local autocmd = vim.api.nvim_create_autocmd

---全体共通設定のaugroup_id
---@return integer
M.vimrc_augroup = vim.api.nvim_create_augroup("vimrc", { clear = false })

---@diagnostic disable-next-line duplicate-doc-alias
---@alias AutocmdEvents vim.api.keyset.events|vim.api.keyset.events[] nvim_create_autocmd event args

---@class AutocmdCallbackFuncArg
---@diagnostic disable-next-line duplicate-doc-field
---@field id number
---@diagnostic disable-next-line duplicate-doc-field
---@field event vim.api.keyset.events
---@diagnostic disable-next-line duplicate-doc-field
---@field group number|nil
---@diagnostic disable-next-line duplicate-doc-field
---@field file string
---@diagnostic disable-next-line duplicate-doc-field
---@field match string
---@diagnostic disable-next-line duplicate-doc-field
---@field buf number
---@diagnostic disable-next-line duplicate-doc-field
---@field data any

---@diagnostic disable-next-line duplicate-doc-alias
---@alias AutocmdCallbackFunc fun(arg?: AutocmdCallbackFuncArg)

---autocmd単発用
---自動でvimrcグループにセットする
---@param events AutocmdEvents
---@param pattern string[]|string
---@param callback AutocmdCallbackFunc|string
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
---@param autocmds {
---    events: AutocmdEvents,
---    pattern: string|string[],
---    group: string|integer,
---    callback: AutocmdCallbackFunc|string,
---    }[]
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
    return vim.fn.expand("%:p:h")
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
    return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(hl_name)), type, mode)
end

---check is files exists in path.
---@param path string
---@param files string[]
---@return boolean
function M.is_files_found(path, files)
    return vim.iter(files):any(function(file)
        return vim.uv.fs_stat(vim.fs.joinpath(path, file)) ~= nil
    end)
end

---Transform 'if statement' into an expression
---@generic T : any
---@param cond boolean
---@param right T
---@param left T
---@return T
function M.ifx(cond, right, left)
    if cond then
        return right
    else
        return left
    end
end

return M
