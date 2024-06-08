local noremap_silent = { silent = true, noremap = true }
local noremap = { noremap = true }

require("user.utils").keymaps_set({
    -- { mode = {}, lhs = [[]], rhs = [[]], opts = opts },

    -- disables
    { -- disable of "s"
        mode = { "n", "x" },
        lhs = [[s]],
        rhs = [[<Nop>]],
        opts = noremap_silent,
    },
    { -- disable of "S"
        mode = { "n", "x" },
        lhs = [[S]],
        rhs = [[<Nop>]],
        opts = noremap_silent,
    },
    { -- disable of marker
        mode = { "n", "x" },
        lhs = [[m]],
        rhs = [[<Nop>]],
        opts = noremap_silent,
    },
    { -- disable of marker
        mode = { "n", "x" },
        lhs = [[']],
        rhs = [[<Nop>]],
        opts = noremap_silent,
    },
    { -- disable of marker
        mode = { "n", "x" },
        lhs = [[`]],
        rhs = [[<Nop>]],
        opts = noremap_silent,
    },
    { -- disable move left after space
        mode = { "n", "x" },
        lhs = [[ ]],
        rhs = [[<Nop>]],
        opts = noremap_silent,
    },
    { -- disable arrow key "→"
        mode = { "", "!" },
        lhs = [[<Left>]],
        rhs = [[<Nop>]],
        opts = noremap_silent,
    },
    { -- disable arrow key "↓"
        mode = { "", "!" },
        lhs = [[<Down>]],
        rhs = [[<Nop>]],
        opts = noremap_silent,
    },
    { -- disable arrow key "↑"
        mode = { "", "!" },
        lhs = [[<Up>]],
        rhs = [[<Nop>]],
        opts = noremap_silent,
    },
    { -- disable arrow key "←"
        mode = { "", "!" },
        lhs = [[<Right>]],
        rhs = [[<Nop>]],
        opts = noremap_silent,
    },
    { -- disable of marker
        mode = { "n", "x" },
        lhs = [[m]],
        rhs = [[<Nop>]],
        opts = noremap_silent,
    },
    { -- disable of marker
        mode = { "n", "x" },
        lhs = [[']],
        rhs = [[<Nop>]],
        opts = noremap_silent,
    },
    { -- disable of marker
        mode = { "n", "x" },
        lhs = [[`]],
        rhs = [[<Nop>]],
        opts = noremap_silent,
    },
    { -- disable move left after space
        mode = { "n", "x" },
        lhs = [[ ]],
        rhs = [[<Nop>]],
        opts = noremap_silent,
    },
    { -- disable arrow key "→"
        mode = { "", "!" },
        lhs = [[<Left>]],
        rhs = [[<Nop>]],
        opts = noremap_silent,
    },
    { -- disable arrow key "↓"
        mode = { "", "!" },
        lhs = [[<Down>]],
        rhs = [[<Nop>]],
        opts = noremap_silent,
    },
    { -- disable arrow key "↑"
        mode = { "", "!" },
        lhs = [[<Up>]],
        rhs = [[<Nop>]],
        opts = noremap_silent,
    },
    { -- disable arrow key "←"
        mode = { "", "!" },
        lhs = [[<Right>]],
        rhs = [[<Nop>]],
        opts = noremap_silent,
    },

    -- window
    { -- key prefix of window control
        mode = { "n" },
        lhs = [[ w]],
        rhs = [[<Plug>(Window)]],
        opts = {},
    },
    { -- save current buffer
        mode = { "n" },
        lhs = [[<Plug>(Window)w]],
        rhs = [[<Cmd>update<CR>]],
        opts = noremap_silent,
    },
    { -- save current buffer
        mode = { "n" },
        lhs = [[<Plug>(Window)W]],
        rhs = [[<Cmd>write<CR>]],
        opts = noremap_silent,
    },
    { -- Ctrl-W_h
        mode = { "n" },
        lhs = [[<Plug>(Window)h]],
        rhs = [[<C-W>h]],
        opts = noremap_silent,
    },
    { -- Ctrl-W_j
        mode = { "n" },
        lhs = [[<Plug>(Window)j]],
        rhs = [[<C-W>j]],
        opts = noremap_silent,
    },
    { -- Ctrl-W_k
        mode = { "n" },
        lhs = [[<Plug>(Window)k]],
        rhs = [[<C-W>k]],
        opts = noremap_silent,
    },
    { -- Ctrl-W_l
        mode = { "n" },
        lhs = [[<Plug>(Window)l]],
        rhs = [[<C-W>l]],
        opts = noremap_silent,
    },
    { -- Ctrl-W_H
        mode = { "n" },
        lhs = [[<Plug>(Window)H]],
        rhs = [[<C-W>H]],
        opts = noremap_silent,
    },
    { -- Ctrl-W_J
        mode = { "n" },
        lhs = [[<Plug>(Window)J]],
        rhs = [[<C-W>J]],
        opts = noremap_silent,
    },
    { -- Ctrl-W_K
        mode = { "n" },
        lhs = [[<Plug>(Window)K]],
        rhs = [[<C-W>K]],
        opts = noremap_silent,
    },
    { -- Ctrl-W_L
        mode = { "n" },
        lhs = [[<Plug>(Window)L]],
        rhs = [[<C-W>L]],
        opts = noremap_silent,
    },
    { -- Ctrl-W_q
        mode = { "n" },
        lhs = [[<Plug>(Window)q]],
        rhs = [[<C-W>q]],
        opts = noremap_silent,
    },
    { -- Ctrl-W_s
        mode = { "n" },
        lhs = [[<Plug>(Window)s]],
        rhs = [[<C-W>s]],
        opts = noremap_silent,
    },
    { -- Ctrl-W_v
        mode = { "n" },
        lhs = [[<Plug>(Window)v]],
        rhs = [[<C-W>v]],
        opts = noremap_silent,
    },
    { -- Ctrl-W_n
        mode = { "n" },
        lhs = [[<Plug>(Window)n]],
        rhs = [[<C-W>n]],
        opts = noremap_silent,
    },
    { -- Ctrl-W _
        mode = { "n" },
        lhs = [[<Plug>(Window)_]],
        rhs = [[<C-W>_]],
        opts = noremap_silent,
    },
    { -- Ctrl-W |
        mode = { "n" },
        lhs = [[<Plug>(Window)|]],
        rhs = [[<C-W>|]],
        opts = noremap_silent,
    },
    { -- Ctrl-W =
        mode = { "n" },
        lhs = [[<Plug>(Window)=]],
        rhs = [[<C-W>=]],
        opts = noremap_silent,
    },
    { -- Ctrl-W_<
        mode = { "n" },
        lhs = [[<S-Left>]],
        rhs = [[<C-w><]],
        opts = noremap_silent,
    },
    { -- Ctrl-W_>
        mode = { "n" },
        lhs = [[<S-Right>]],
        rhs = [[<C-w>>]],
        opts = noremap_silent,
    },
    { -- Ctrl-W_-
        mode = { "n" },
        lhs = [[<S-Up>]],
        rhs = [[<C-w>-]],
        opts = noremap_silent,
    },
    { -- Ctrl-W_+
        mode = { "n" },
        lhs = [[<S-Down>]],
        rhs = [[<C-w>+]],
        opts = noremap_silent,
    },

    -- quickfix
    { -- cprevious
        mode = { "n" },
        lhs = [=[[q]=],
        rhs = [[<Cmd>cprevious<CR>]],
        opts = noremap_silent,
    },
    { -- cnext
        mode = { "n" },
        lhs = [=[]q]=],
        rhs = [[<Cmd>cnext<CR>]],
        opts = noremap_silent,
    },
    { -- cfirst
        mode = { "n" },
        lhs = [=[[Q]=],
        rhs = [[<Cmd>cfirst<CR>]],
        opts = noremap_silent,
    },
    { -- clast
        mode = { "n" },
        lhs = [=[]Q]=],
        rhs = [[<Cmd>clast<CR>]],
        opts = noremap_silent,
    },

    -- buffer
    { -- bprevious
        mode = { "n" },
        lhs = [=[[b]=],
        rhs = [[<Cmd>bprevious<CR>]],
        opts = noremap_silent,
    },
    { -- bnext
        mode = { "n" },
        lhs = [=[]b]=],
        rhs = [[<Cmd>bnext<CR>]],
        opts = noremap_silent,
    },
    { -- bfirst
        mode = { "n" },
        lhs = [=[[B]=],
        rhs = [[<Cmd>bfirst<CR>]],
        opts = noremap_silent,
    },
    { -- blast
        mode = { "n" },
        lhs = [=[]B]=],
        rhs = [[<Cmd>blast<CR>]],
        opts = noremap_silent,
    },

    -- tab
    { -- tabprevious
        mode = { "n" },
        lhs = [=[[t]=],
        rhs = [[gT]],
        opts = noremap_silent,
    },
    { -- tabnext
        mode = { "n" },
        lhs = [=[]t]=],
        rhs = [[gt]],
        opts = noremap_silent,
    },
    { -- tabfirst
        mode = { "n" },
        lhs = [=[[T]=],
        rhs = [[<Cmd>tabfirst<CR>]],
        opts = noremap_silent,
    },
    { -- tablast
        mode = { "n" },
        lhs = [=[]T]=],
        rhs = [[<Cmd>tablast<CR>]],
        opts = noremap_silent,
    },
    { -- tabnew
        mode = { "n" },
        lhs = [[<Plug>(Window)tn]],
        rhs = [[<Cmd>tabnew<CR>]],
        opts = noremap_silent,
    },
    { -- Ctrl-W_T
        mode = { "n" },
        lhs = [[<Plug>(Window)tT]],
        rhs = [[<C-W>T]],
        opts = noremap_silent,
    },

    -- useful keymaps
    { -- xとかcでレジスターに入るのウザいよね…
        mode = { "n", "x" },
        lhs = [[x]],
        rhs = [["_x]],
        opts = noremap_silent,
    },
    { -- xとかcでレジスターに入るのウザいよね…
        mode = { "n", "x" },
        lhs = [[c]],
        rhs = [["_c]],
        opts = noremap_silent,
    },
    { -- gfもgFもやってること変わらんのよね…
        mode = { "n" },
        lhs = [[gf]],
        rhs = function()
            local cfile = tostring(vim.fn.expand("<cfile>"))
            if cfile:match("^https?://") then
                vim.ui.open(cfile)
            else
                if vim.fn.filereadable(cfile) ~= 1 then
                    vim.fn.system({ "touch", tostring(vim.fn.expand(cfile)) })
                end
                vim.cmd([[normal! gF]])
            end
        end,
        opts = noremap_silent,
    },
    { -- qって結構誤爆するんだよね…
        mode = { "n", "x" },
        lhs = [[<C-Q>]],
        rhs = [[q]],
        opts = noremap_silent,
    },
    { -- ↑を見てこいカルロ
        mode = { "n", "x" },
        lhs = [[q]],
        rhs = [[<Nop>]],
        opts = noremap_silent,
    },
    { -- よく見るやつ。icで使えるようにしてみる
        mode = { "i", "c" },
        lhs = [[jj]],
        rhs = [[<Esc><C-l>]],
        opts = noremap_silent,
    },
    { -- Ctrl-lで<Del>
        mode = { "i", "c" },
        lhs = [[<C-l>]],
        rhs = [[<Del>]],
        opts = noremap,
    },

    -- Emacs like
    -- 言う程、インサートモードで使わんのよね…
    -- <C-f/b>はスニペットジャンプに使ってます
    -- { mode = {"i"}, lhs = [[<C-f>]], rhs = [[<C-G>U<Right>]], opts = opts },
    -- { mode = {"i"}, lhs = [[<C-b>]], rhs = [[<C-G>U<Left>]], opts = opts },
    -- { mode = {"i"}, lhs = [[<C-e>]], rhs = [[<C-G>U<End>]], opts = opts },
    -- { mode = {"c"}, lhs = [[<C-e>]], rhs = [[<End>]], opts = { noremap = true } },
    -- 行頭/行末ジャンプは設定はddcのキーマップを確認
    {
        mode = { "i" },
        lhs = [[<C-a>]],
        rhs = [[<C-o>^]],
        opts = noremap_silent,
    },
    {
        mode = { "c" },
        lhs = [[<C-a>]],
        rhs = [[<Home>]],
        opts = noremap,
    },
    {
        mode = { "c" },
        lhs = [[<C-f>]],
        rhs = [[<Right>]],
        opts = noremap,
    },
    {
        mode = { "c" },
        lhs = [[<C-b>]],
        rhs = [[<Left>]],
        opts = noremap,
    },

    -- operator
    { -- a'
        mode = { "x", "o" },
        lhs = [[a']],
        rhs = [[2i']],
        opts = noremap_silent,
    },
    { -- a"
        mode = { "x", "o" },
        lhs = [[a"]],
        rhs = [[2i"]],
        opts = noremap_silent,
    },
    { -- a`
        mode = { "x", "o" },
        lhs = [[a`]],
        rhs = [[2i`]],
        opts = noremap_silent,
    },
    { -- i<Space>
        mode = { "x", "o" },
        lhs = [[i ]],
        rhs = [[iW]],
        opts = noremap_silent,
    },
    { -- a<Space>
        mode = { "x", "o" },
        lhs = [[a ]],
        rhs = [[aW]],
        opts = noremap_silent,
    },
})
