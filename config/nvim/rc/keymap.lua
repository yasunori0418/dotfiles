local opts = { silent = true, noremap = true }

local keymaps = {
  { mode = {"n", "x"}, lhs = "s", rhs = "" },
  { mode = {"n", "x"}, lhs = "S", rhs = "" },
  { mode = {"n", "x"}, lhs = "t", rhs = "" },
  { mode = {"n", "x"}, lhs = "T", rhs = "" },
  { mode = {"n", "x"}, lhs = "m", rhs = "" },
  { mode = {"n", "x"}, lhs = "'", rhs = "" },
  { mode = {"n", "x"}, lhs = "`", rhs = "" },
  { mode = {"n", "x"}, lhs = " ", rhs = "" },
  { mode = {"", "!"}, lhs = "<Left>", rhs = "" },
  { mode = {"", "!"}, lhs = "<Down>", rhs = "" },
  { mode = {"", "!"}, lhs = "<Up>", rhs = "" },
  { mode = {"", "!"}, lhs = "<Right>", rhs = "" },
}

for _, keymap in pairs(keymaps) do
  vim.keymap.set(keymap.mode, keymap.lhs, keymap.rhs, opts)
end
