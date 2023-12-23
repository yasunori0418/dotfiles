local function l2x_rom()
    local rom = {}
    local disable_l_nexts =
        vim.fn.split([=[bcdfghjkmnpqrsvxzBCDFGHJKMNPQRSVXZ,./1234567890-+=`~;:[]{}()<>!@#$%^&*_\"']=], [[\zs]])

    vim.fn.map(disable_l_nexts, function(_, value)
        rom["l" .. value] = { "", "" }
    end)

    local converts = {
        la = { "ぁ", "" },
        li = { "ぃ", "" },
        lu = { "ぅ", "" },
        le = { "ぇ", "" },
        lo = { "ぉ", "" },
        ll = { "っ", "l" },
        ltu = { "っ", "" },
        ltsu = { "っ", "" },
        lwa = { "ゎ", "" },
        lwe = { "ゑ", "" },
        lwi = { "ゐ", "" },
        lya = { "ゃ", "" },
        lyo = { "ょ", "" },
        lyu = { "ゅ", "" },
        xa = { "", "" },
        xi = { "", "" },
        xu = { "", "" },
        xe = { "", "" },
        xo = { "", "" },
        xx = { "", "" },
        xtu = { "", "" },
        xtsu = { "", "" },
        xwa = { "", "" },
        xwe = { "", "" },
        xwi = { "", "" },
        xya = { "", "" },
        xyo = { "", "" },
        xyu = { "", "" },
    }

    vim.fn.map(converts, function(key, value)
        rom[key] = value
    end)

    return rom
end

local function l2x_maps()
    vim.fn['skkeleton#register_kanatable']("rom", l2x_rom())
    vim.fn['skkeleton#register_keymap']("input", "x", "disable")
    vim.fn['skkeleton#register_keymap']("input", "X", "zenkaku")
    vim.fn['skkeleton#register_kanatable']("rom", {
        ["<s-x>"] = "zenkaku",
    })
    vim.fn['skkeleton#register_kanatable']("rom", {
        ["<s-l>"] = { "L", "" },
    }, true)
end

local joinpath = vim.fs.joinpath
local repos_github = "~/.cache/dpp/repos/github.com"
local basic_dict = "skk-dev/dict"
local jawiki_dict = "tokuhirom/jawiki-kana-kanji-dict"

local M = {}

function M.init()
    vim.fn['skkeleton#config']({
        eggLikeNewline = true,
        globalDictionaries = {
            {
                joinpath(repos_github, basic_dict, "SKK-JISYO.L"),
                [[euc-jp]],
            },
            {
                joinpath(repos_github, basic_dict, "SKK-JISYO.propernoun"),
                [[euc-jp]],
            },
            {
                joinpath(repos_github, jawiki_dict, "SKK-JISYO.jawiki"),
                [[euc-jp]],
            },
            {
                joinpath(repos_github, basic_dict, "SKK-JISYO.emoji"),
                [[utf-8]],
            },
            {
                joinpath(repos_github, basic_dict, "SKK-JISYO.jinmei"),
                [[euc-jp]],
            },
        },
        userJisyo = [[~/.skk/skkeleton]],
        completionRankFile = [[~/.skk/rank.json]],
        markerHenkan = "",
        markerHenkanSelect = "",
        registerConvertResult = true,
        usePopup = true,
    })

    vim.fn['skkeleton#register_kanatable']("rom", {
        ["jj"] = "escape",
        ["~"] = { "～", "" },
        ["z0"] = { "○", "" },
        ["("] = { "（", "" },
        [")"] = { "）", "" },
    })
    l2x_maps()
end

function M.pre()
    vim.b.prev_buffer_config = vim.fn['ddc#custom#get_buffer']()
    vim.fn['ddc#custom#patch_buffer']("sources", { "vsnip", "skkeleton" })
end

function M.post()
    vim.fn['ddc#custom#set_buffer'](vim.b.prev_buffer_config)
    vim.b.prev_buffer_config = {}
end

return M
-- $HOOKS_DIR/skkeleton.lua
