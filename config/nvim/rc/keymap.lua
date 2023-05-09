local opts = { silent = true, noremap = true }

require('user.utils').keymaps_set{
  -- { mode = {}, lhs = [[]], rhs = [[]], opts = opts },

  -- disables
  { mode = {"n", "x"}, lhs = [[s]], rhs = [[<Nop>]], opts = opts },
  { mode = {"n", "x"}, lhs = [[S]], rhs = [[<Nop>]], opts = opts },
  { mode = {"n", "x"}, lhs = [[t]], rhs = [[<Nop>]], opts = opts },
  { mode = {"n", "x"}, lhs = [[T]], rhs = [[<Nop>]], opts = opts },
  { mode = {"n", "x"}, lhs = [[m]], rhs = [[<Nop>]], opts = opts },
  { mode = {"n", "x"}, lhs = [[']], rhs = [[<Nop>]], opts = opts },
  { mode = {"n", "x"}, lhs = [[`]], rhs = [[<Nop>]], opts = opts },
  { mode = {"n", "x"}, lhs = [[ ]], rhs = [[<Nop>]], opts = opts },
  { mode = {"", "!"}, lhs = [[<Left>]], rhs = [[<Nop>]], opts = opts },
  { mode = {"", "!"}, lhs = [[<Down>]], rhs = [[<Nop>]], opts = opts },
  { mode = {"", "!"}, lhs = [[<Up>]], rhs = [[<Nop>]], opts = opts },
  { mode = {"", "!"}, lhs = [[<Right>]], rhs = [[<Nop>]], opts = opts },

  -- keymap prefix for lsp plugins
  { mode = {"n"}, lhs = [[ l]], rhs = [[<Plug>(lsp)]], opts = {} },
  { mode = {"n"}, lhs = [[<C-g>]], rhs = [[<Plug>(git)]], opts = {} },
  { mode = {"n"}, lhs = [[ w]], rhs = [[<Plug>(Window)]], opts = {} },

  -- window
  { mode = {"n"}, lhs = [[<Plug>(Window)w]], rhs = [[<Cmd>update<CR>]], opts = opts },
  { mode = {"n"}, lhs = [[<Plug>(Window)W]], rhs = [[<Cmd>write<CR>]], opts = opts },
  { mode = {"n"}, lhs = [[<Plug>(Window)h]], rhs = [[<C-W>h]], opts = opts },
  { mode = {"n"}, lhs = [[<Plug>(Window)j]], rhs = [[<C-W>j]], opts = opts },
  { mode = {"n"}, lhs = [[<Plug>(Window)k]], rhs = [[<C-W>k]], opts = opts },
  { mode = {"n"}, lhs = [[<Plug>(Window)l]], rhs = [[<C-W>l]], opts = opts },
  { mode = {"n"}, lhs = [[<Plug>(Window)H]], rhs = [[<C-W>H]], opts = opts },
  { mode = {"n"}, lhs = [[<Plug>(Window)J]], rhs = [[<C-W>J]], opts = opts },
  { mode = {"n"}, lhs = [[<Plug>(Window)K]], rhs = [[<C-W>K]], opts = opts },
  { mode = {"n"}, lhs = [[<Plug>(Window)L]], rhs = [[<C-W>L]], opts = opts },
  { mode = {"n"}, lhs = [[<Plug>(Window)q]], rhs = [[<C-W>q]], opts = opts },
  { mode = {"n"}, lhs = [[<Plug>(Window)s]], rhs = [[<C-W>s]], opts = opts },
  { mode = {"n"}, lhs = [[<Plug>(Window)v]], rhs = [[<C-W>v]], opts = opts },
  { mode = {"n"}, lhs = [[<Plug>(Window)n]], rhs = [[<C-W>n]], opts = opts },
  { mode = {"n"}, lhs = [[<S-Left>]], rhs = [[<C-w><]], opts = opts },
  { mode = {"n"}, lhs = [[<S-Right>]], rhs = [[<C-w>>]], opts = opts },
  { mode = {"n"}, lhs = [[<S-Up>]], rhs = [[<C-w>-]], opts = opts },
  { mode = {"n"}, lhs = [[<S-Down>]], rhs = [[<C-w>+]], opts = opts },

  -- quickfix
  { mode = {"n"}, lhs = [=[[q]=], rhs = [[<Cmd>cprevious<CR>]], opts = opts },
  { mode = {"n"}, lhs = [=[]q]=], rhs = [[<Cmd>cnext<CR>]], opts = opts },
  { mode = {"n"}, lhs = [=[[Q]=], rhs = [[<Cmd>cfirst<CR>]], opts = opts },
  { mode = {"n"}, lhs = [=[]Q]=], rhs = [[<Cmd>clast<CR>]], opts = opts },

  -- buffer
  { mode = {"n"}, lhs = [=[[b]=], rhs = [[<Cmd>bprevious<CR>]], opts = opts },
  { mode = {"n"}, lhs = [=[]b]=], rhs = [[<Cmd>bnext<CR>]], opts = opts },
  { mode = {"n"}, lhs = [=[[B]=], rhs = [[<Cmd>bfirst<CR>]], opts = opts },
  { mode = {"n"}, lhs = [=[]B]=], rhs = [[<Cmd>blast<CR>]], opts = opts },

  -- tab
  { mode = {"n"}, lhs = [=[[t]=], rhs = [[gT]], opts = opts },
  { mode = {"n"}, lhs = [=[]t]=], rhs = [[gt]], opts = opts },
  { mode = {"n"}, lhs = [=[[T]=], rhs = [[<Cmd>tabfirst<CR>]], opts = opts },
  { mode = {"n"}, lhs = [=[]T]=], rhs = [[<Cmd>tablast<CR>]], opts = opts },
  { mode = {"n"}, lhs = [[tn]], rhs = [[<Cmd>tabnew<CR>]], opts = opts },
  { mode = {"n"}, lhs = [[tt]], rhs = [[<C-W>g<Tab>]], opts = opts },
  { mode = {"n"}, lhs = [[tT]], rhs = [[<C-W>T]], opts = opts },

  -- xとかcでレジスターに入るのウザいよね…
  { mode = {"n", "x"}, lhs = [[x]], rhs = [["_x]], opts = opts },
  { mode = {"n", "x"}, lhs = [[c]], rhs = [["_c]], opts = opts },

  { mode = {"n"}, lhs = [[gf]], rhs = [[gF]], opts = opts },
  { mode = {"n"}, lhs = [[<C-l>]], rhs = [[<Cmd>nohlsearch<Bar>diffupdate<CR><C-l>]], opts = opts },
  { mode = {"n"}, lhs = [[ n]], rhs = vim.fn['vimrc#signcolumn'], opts = opts },
  { mode = {"n"}, lhs = [[Q]], rhs = [[q]], opts = opts },
  { mode = {"n"}, lhs = [[q]], rhs = "", opts = opts },
  { mode = {"i"}, lhs = [[jj]], rhs = [[<Esc>]], opts = opts },
  { mode = {"c"}, lhs = [[jj]], rhs = [[<Esc><C-l>]], opts = opts },
  { mode = {"i", "c"}, lhs = [[<C-l>]], rhs = [[<Del>]], opts = opts },

  -- Emacs like
  -- 言う程、インサートモードで使わんのよね…
  -- <C-f/b>はスニペットジャンプに使ってます
  -- { mode = {"i"}, lhs = [[<C-f>]], rhs = [[<C-G>U<Right>]], opts = opts },
  -- { mode = {"i"}, lhs = [[<C-b>]], rhs = [[<C-G>U<Left>]], opts = opts },
  -- { mode = {"i"}, lhs = [[<C-a>]], rhs = [[<C-o>^]], opts = opts },
  -- { mode = {"i"}, lhs = [[<C-e>]], rhs = [[<C-G>U<End>]], opts = opts },
  { mode = {"c"}, lhs = [[<C-a>]], rhs = [[<Home>]], opts = { noremap = true } },
  { mode = {"c"}, lhs = [[<C-f>]], rhs = [[<Right>]], opts = { noremap = true } },
  { mode = {"c"}, lhs = [[<C-b>]], rhs = [[<Left>]], opts = { noremap = true } },
  { mode = {"c"}, lhs = [[<C-e>]], rhs = [[<End>]], opts = { noremap = true } },

  { mode = {"x", "o"}, lhs = [[a']], rhs = [[2i']], opts = opts },
  { mode = {"x", "o"}, lhs = [[a"]], rhs = [[2i"]], opts = opts },
  { mode = {"x", "o"}, lhs = [[a`]], rhs = [[2i`]], opts = opts },
}
