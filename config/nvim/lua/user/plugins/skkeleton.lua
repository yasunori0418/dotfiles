local vimx = require("artemis")

local skkeleton = vimx.fn.skkeleton
local ddc_custom = vimx.fn.ddc.custom

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
    skkeleton.register_kanatable("rom", l2x_rom())
    skkeleton.register_keymap("input", "x", "disable")
    skkeleton.register_keymap("input", "X", "zenkaku")
    skkeleton.register_kanatable("rom", {
        ["<s-x>"] = "zenkaku",
    })
    skkeleton.register_kanatable("rom", {
        ["<s-l>"] = { "L", "" },
    }, true)
end

local joinpath = vim.fs.joinpath
local repos_github = "~/.cache/dein/repos/github.com"
local basic_dict = "skk-dev/dict"
local jawiki_dict = "tokuhirom/jawiki-kana-kanji-dict"

local M = {}

function M.init()
    skkeleton.config({
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

    skkeleton.register_kanatable("rom", {
        ["jj"] = "escape",
        ["~"] = { "～", "" },
        ["z0"] = { "○", "" },
        ["("] = { "（", "" },
        [")"] = { "）", "" },
    })
    l2x_maps()
end

function M.pre()
    vim.b.prev_buffer_config = ddc_custom.get_buffer()
    ddc_custom.patch_buffer("sources", { "vsnip", "skkeleton" })
end

function M.post()
    ddc_custom.set_buffer(vim.b.prev_buffer_config)
    vim.b.prev_buffer_config = {}
end

return M
-- $HOOKS_DIR/skkeleton.lua
