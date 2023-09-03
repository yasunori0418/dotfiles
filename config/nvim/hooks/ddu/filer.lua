-- lua_ddu-filer {{{
local opt = { buffer = true, noremap = true }
local opt_expr = { buffer = true, expr = true, noremap = true }

local do_action = vim.fn["ddu#ui#do_action"]
local multi_actions = vim.fn["ddu#ui#multi_actions"]
local get_item = vim.fn["ddu#ui#get_item"]

require("user.utils").keymaps_set({
  { -- if directory then expand. if file then open.
    mode = "n",
    lhs = [[<CR>]],
    rhs = function()
      if get_item()["isTree"] then
        do_action([[expandItem]], { mode = [[toggle]] })
      else
        do_action([[itemAction]], {
          name = [[open]],
          params = { command = [[drop]] },
        })
      end
    end,
    opts = opt,
  },
  { -- open select item with vertical split.
    mode = "n",
    lhs = [[v]],
    rhs = function()
      do_action([[itemAction]], {
        name = [[open]],
        params = { command = [[vsplit]] },
      })
    end,
    opts = opt,
  },
  { -- open select item with horizontal split
    mode = "n",
    lhs = [[s]],
    rhs = function()
      do_action([[itemAction]], {
        name = [[open]],
        params = { command = [[split]] },
      })
    end,
    opts = opt,
  },
  { -- open select item with tabedit.
    mode = "n",
    lhs = [[t]],
    rhs = function()
      do_action([[itemAction]], {
        name = [[open]],
        params = { command = [[tabedit]] },
      })
    end,
    opts = opt,
  },
  { -- expand directory at selected.
    mode = "n",
    lhs = [[o]],
    rhs = function()
      do_action([[expandItem]], { mode = [[toggle]] })
    end,
    opts = opt,
  },
  { -- expand all directories recursively
    mode = "n",
    lhs = [[O]],
    rhs = function()
      do_action([[expandItem]], { maxLevel = -1 })
    end,
    opts = opt,
  },

  -- support
  { -- preview file... not working?
    mode = "n",
    lhs = [[p]],
    rhs = function()
      do_action([[togglePreview]])
    end,
    opts = opt,
  },
  { -- show select action list
    mode = "n",
    lhs = [[a]],
    rhs = function()
      do_action([[chooseAction]])
    end,
    opts = opt,
  },
  { -- select item
    mode = "n",
    lhs = [[  ]],
    rhs = function()
      do_action([[toggleSelectItem]])
    end,
    opts = opt,
  },
  { -- select all item
    mode = "n",
    lhs = [[*]],
    rhs = function()
      do_action([[toggleAllItems]])
    end,
    opts = opt,
  },
  { -- close filer window.
    mode = "n",
    lhs = [[q]],
    rhs = function()
      do_action([[quit]])
    end,
    opts = opt,
  },
  { -- close filer window.
    mode = "n",
    lhs = [[<Esc>]],
    rhs = function()
      do_action([[quit]])
    end,
    opts = opt,
  },
  { -- jump first line when last line.
    mode = "n",
    lhs = [[j]],
    rhs = function()
      if vim.fn.line([[.]]) == vim.fn.line([[$]]) then
        return [[gg]]
      else
        return [[j]]
      end
    end,
    opts = opt_expr,
  },
  { -- jump last line when first line.
    mode = "n",
    lhs = [[k]],
    rhs = function()
      if vim.fn.line([[.]]) == 1 then
        return [[G]]
      else
        return [[k]]
      end
    end,
    opts = opt_expr,
  },

  -- controll
  { -- copy file_or_directory
    mode = "n",
    lhs = [[C]],
    rhs = function()
      multi_actions({
        { [[itemAction]],         { name = [[copy]] } },
        { [[clearSelectAllItems]] },
      })
    end,
    opts = opt,
  },
  { -- move file_or_directory
    mode = "n",
    lhs = [[M]],
    rhs = function()
      multi_actions({
        { [[itemAction]],         { name = [[move]] } },
        { [[clearSelectAllItems]] },
      })
    end,
    opts = opt,
  },
  { -- paste file_or_directory
    mode = "n",
    lhs = [[P]],
    rhs = function()
      do_action([[itemAction]], { name = [[paste]] })
    end,
    opts = opt,
  },
  { -- rename
    mode = "n",
    lhs = [[R]],
    rhs = function()
      do_action([[itemAction]], { name = [[rename]] })
    end,
    opts = opt,
  },
  { -- delete command prefix
    mode = "n",
    lhs = [[ d]],
    rhs = [[<Plug>(delete)]],
    opts = opt,
  },
  { -- mv `target_file_directory` $TRASH
    mode = "n",
    lhs = [[<Plug>(delete)d]],
    rhs = function()
      do_action([[itemAction]], { name = [[trash]] })
    end,
    opts = opt,
  },
  { -- rm `target_file_directory`
    mode = "n",
    lhs = [[<Plug>(delete)D]],
    rhs = function()
      do_action([[itemAction]], { name = [[delete]] })
    end,
    opts = opt,
  },
  { -- Create new file or directory
    mode = "n",
    lhs = [[N]],
    rhs = function()
      do_action([[itemAction]], { name = [[newFile]] })
    end,
    opts = opt,
  },
  { -- undo
    mode = "n",
    lhs = [[u]],
    rhs = function()
      do_action([[itemAction]], { name = [[undo]] })
    end,
    opts = opt,
  },
  { -- yank path
    mode = "n",
    lhs = [[y]],
    rhs = function()
      do_action([[itemAction]], { name = [[yank]] })
      print([[Yank path the "]] .. vim.fn.getreg([[+]]) .. [["]])
    end,
    opts = opt,
  },

  { -- cd $HOME
    mode = "n",
    lhs = [[~]],
    rhs = function()
      do_action([[itemAction]], {
        name = [[narrow]],
        params = { path = vim.env.HOME },
      })
    end,
    opts = opt,
  },
  { -- path_history-filer
    mode = "n",
    lhs = [[H]],
    rhs = function()
      vim.fn["ddu#start"]({ name = [[path_history]] })
    end,
    opts = opt,
  },
  { -- cd ..
    mode = "n",
    lhs = [[..]],
    rhs = function()
      do_action([[itemAction]], {
        name = [[narrow]],
        params = { path = [[..]] },
      })
    end,
    opts = opt,
  },
  { -- cd target_directory.
    mode = "n",
    lhs = [[c]],
    rhs = function()
      do_action([[itemAction]], { name = [[narrow]] })
    end,
    opts = opt,
  },
})

-- }}}
