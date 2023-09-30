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
---@param keymaps { mode: table|string, lhs: string, rhs: string|function, opts: table|nil }
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
---@return string|string[]
function M.search_repo_root()
    local result = io.popen("git root 2> /dev/null", "r"):read("*l")
    if result then
        return result
    end
    return vim.fn.expand("%:p:h")
end

---signcolumnの表示をtoggleする。
function M.toggle_view()
    local gitsigns = require("gitsigns")
    if vim.opt.number:get() then
        vim.opt.number = false
        vim.opt.relativenumber = false
        vim.opt.laststatus = 0
        vim.opt.showtabline = 0
        gitsigns.toggle_signs(false)
    else
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.laststatus = 3
        vim.opt.showtabline = 1
        gitsigns.toggle_signs(true)
    end
end

---ディレクトリ内からファイルリストを取得して、
---全ての要素をフルパスにした物を配列にして返す
---@param base_dir string
---@param config_dir_name string
---@return Iter
function M.gather_files(base_dir, config_dir_name)
    local config_dir = vim.fs.joinpath(base_dir, config_dir_name)
    return vim.iter(vim.fs.dir(config_dir)):map(function(file_name)
        return vim.fs.joinpath(config_dir, file_name)
    end)
end

---gather_filesから特定のファイルパスを削除する。
---@param gather_files Iter
---@param file_name string
---@return Iter
function M.remove_file_from_gather_files(gather_files, file_name)
    gather_files:filter(function(file_path)
        return vim.fn.fnamemodify(file_path, ":t") ~= file_name
    end)
    return gather_files
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

return M
