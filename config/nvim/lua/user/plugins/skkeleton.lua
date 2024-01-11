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
    vim.fn["skkeleton#register_kanatable"]("rom", l2x_rom())
    vim.fn["skkeleton#register_keymap"]("input", "x", "disable")
    vim.fn["skkeleton#register_keymap"]("input", "X", "zenkaku")
    vim.fn["skkeleton#register_kanatable"]("rom", {
        ["<s-x>"] = "zenkaku",
    })
    vim.fn["skkeleton#register_kanatable"]("rom", {
        ["<s-l>"] = { "L", "" },
    }, true)
end

local joinpath = vim.fs.joinpath
local dpp = require("dpp")
local basic_dict = dpp.get("dict").path
local jawiki_dict = dpp.get("jawiki-kana-kanji-dict").path

local M = {}

function M.init()
    vim.fn["skkeleton#config"]({
        eggLikeNewline = true,
        globalDictionaries = {
            joinpath(basic_dict, "SKK-JISYO.L"),
            joinpath(basic_dict, "SKK-JISYO.propernoun"),
            joinpath(jawiki_dict, "SKK-JISYO.jawiki"),
            joinpath(basic_dict, "SKK-JISYO.emoji"),
            joinpath(basic_dict, "SKK-JISYO.jinmei"),
        },
        sources = { "skk_dictionary", "deno_kv" },
        userDictionary = [[~/.skk/skkeleton]],
        databasePath = vim.fn.expand([[~/.skk/skkeleton.db]]),
        completionRankFile = [[~/.skk/rank.json]],
        markerHenkan = "",
        markerHenkanSelect = "",
        registerConvertResult = true,
        usePopup = true,
    })

    vim.fn["skkeleton#register_kanatable"]("rom", {
        ["jj"] = "escape",
        ["~"] = { "～", "" },
        ["z0"] = { "○", "" },
        ["("] = { "（", "" },
        [")"] = { "）", "" },
    })
    l2x_maps()
end

function M.pre()
    vim.b.prev_buffer_config = vim.fn["ddc#custom#get_buffer"]()
    vim.fn["ddc#custom#patch_buffer"]("sources", { "skkeleton" })
end

function M.post()
    vim.fn["ddc#custom#set_buffer"](vim.b.prev_buffer_config)
    vim.b.prev_buffer_config = {}
end

return M
-- $HOOKS_DIR/skkeleton.lua
