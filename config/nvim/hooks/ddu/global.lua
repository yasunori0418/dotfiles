-- lua_add {{{
local opt = { noremap = false }
local utils = require("user.utils")
utils.keymaps_set({
  -- ddu start prefixes
  { mode = "n", lhs = [[ d]], rhs = [[<Plug>(ddu-ff)]],    opts = opt },
  { mode = "n", lhs = [[ f]], rhs = [[<Plug>(ddu-filer)]], opts = opt },

  -- ddu-ui-ff starter
  { -- current-ff
    mode = "n",
    lhs = [[<Plug>(ddu-ff)a]],
    rhs = function()
      vim.fn["ddu#start"]({
        name = "current",
        sourceOptions = {
          file_rec = {
            path = utils.search_repo_root(),
          },
        },
      })
    end,
    opts = opt,
  },
  { -- dorfiles-ff
    mode = "n",
    lhs = [[<Plug>(ddu-ff)d]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "dotfiles" })
    end,
    opts = opt,
  },
  { -- help-ff
    mode = "n",
    lhs = [[<Plug>(ddu-ff)h]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "help" })
    end,
    opts = opt,
  },
  { -- buffer-ff
    mode = "n",
    lhs = [[<Plug>(ddu-ff)b]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "buffer" })
    end,
    opts = opt,
  },
  { -- plugin-list-ff
    mode = "n",
    lhs = [[<Plug>(ddu-ff)P]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "plugin-list" })
    end,
    opts = opt,
  },
  { -- home-ff
    mode = "n",
    lhs = [[<Plug>(ddu-ff)~]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "home" })
    end,
    opts = opt,
  },
  { -- register-ff
    mode = "n",
    lhs = [[<Plug>(ddu-ff)r]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "register" })
    end,
    opts = opt,
  },
  { -- ripgrep-ff live grep
    mode = "n",
    lhs = [[<Plug>(ddu-ff)s]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "ripgrep" })
    end,
    opts = opt,
  },
  { -- mrr-ff most recent repositories
    mode = "n",
    lhs = [[<Plug>(ddu-ff)m]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "mrr" })
    end,
    opts = opt,
  },
  { -- mru-ff most recent used files
    mode = "n",
    lhs = [[<Plug>(ddu-ff)n]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "mru" })
    end,
    opts = opt,
  },
  { -- search_line-ff
    mode = "n",
    lhs = [[<Plug>(ddu-ff)/]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "search_line" })
    end,
    opts = opt,
  },
  { -- hightlight-ff
    mode = "n",
    lhs = [[<Plug>(ddu-ff)C]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "highlight" })
    end,
    opts = opt,
  },

  -- git control by ddu
  { -- git_status-ff
    mode = "n",
    lhs = [[<Plug>(git)s]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "git_status" })
    end,
    opts = opt,
  },
  { -- git_log-ff
    mode = "n",
    lhs = [[<Plug>(git)l]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "git_log" })
    end,
    opts = opt,
  },
  { -- git_branch-ff
    mode = "n",
    lhs = [[<Plug>(git)b]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "git_branch" })
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[<Plug>(git)q]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "ghq" })
    end,
    opts = opt,
  },

  -- ddu-ui-filer starter
  { -- project_root-filer
    mode = "n",
    lhs = [[<Plug>(ddu-filer)a]],
    rhs = function()
      vim.fn["ddu#start"]({
        name = "current-filer",
        sourceOptions = {
          file = {
            path = utils.search_repo_root(),
          },
        },
      })
    end,
    opts = opt,
  },
  { -- current-filer open filer at current buffer directory
    mode = "n",
    lhs = [[<Plug>(ddu-filer)f]],
    rhs = function()
      vim.fn["ddu#start"]({
        name = "current-filer",
        sourceOptions = {
          file = {
            path = vim.fn.expand("%:p:h"),
          },
        },
      })
    end,
    opts = opt,
  },
  { -- dotfiles-filer
    mode = "n",
    lhs = [[<Plug>(ddu-filer)d]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "dotfiles-filer" })
    end,
    opts = opt,
  },
  { -- home-filer
    mode = "n",
    lhs = [[<Plug>(ddu-filer)~]],
    rhs = function()
      vim.fn["ddu#start"]({ name = "home-filer" })
    end,
    opts = opt,
  },
})

-- }}}

-- lua_source {{{
local joinpath = vim.fs.joinpath
local ddu_hooks = joinpath(vim.g.hooks_dir, "ddu")
vim.fn["ddu#custom#load_config"](
-- $HOOKS_DIR/ddu/config.ts
  joinpath(ddu_hooks, "config.ts")
)

vim.api.nvim_create_user_command("DeinUpdate", function()
  vim.fn["ddu#start"]({name = "dein_update"})
end, {})

-- }}}
