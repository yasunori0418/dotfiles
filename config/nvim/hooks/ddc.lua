-- lua_add {{{
local commandline_post = function()
  if vim.b.prev_buffer_config then
    vim.fn['ddc#custom#set_buffer'](vim.b.prev_buffer_config)
    vim.b.prev_buffer_config = nil
  end
end
local commandline_pre = function()
  vim.b.prev_buffer_config = vim.fn['ddc#custom#get_buffer']()
  vim.api.nvim_create_autocmd('User', {
    group = require('user.utils').vimrc_augroup,
    pattern = 'DDCCmdlineLeave',
    callback = function() commandline_post() end,
    once = true,
  })
  vim.fn['ddc#enable_cmdline_completion']()
end

require('user.utils').autocmd_set(
  'CmdlineEnter',
  '*',
  function()
    commandline_pre()
  end
)

-- }}}

-- lua_source {{{

-- Source options.
local global_source = {'vsnip', 'around', 'file', 'rg'}

-- Use pum.vim
vim.fn['ddc#custom#patch_global']{
  ui = 'pum',
  sources = global_source,
  autoCompleteEvents = {
    'InsertEnter',
    'TextChangedI',
    'TextChangedP',
    'CmdlineEnter',
    'CmdlineChanged',
    'TextChangedT',
  },
  cmdlineSources = {
    [':'] = {'cmdline', 'cmdline-history', 'around'},
    ['@'] = {'cmdline-history', 'input', 'file', 'around'},
    ['>'] = {'cmdline-history', 'input', 'file', 'around'},
    ['/'] = {'around', 'line'},
    ['?'] = {'around', 'line'},
    ['-'] = {'around', 'line'},
    ['='] = {'input'},
  },
}

---Filter settings
-- Normal filter
-- vim.fn['ddc#custom#patch_global']('sourceOptions', {
--  _ =  {
--    ignoreCase = true,
--    matchers = {'matcher_head', 'matcher_length'},
--    sorters = {'sorter_rank'},
--    converters = {'converter_remove_overlap'},
--    },
--  })

-- Fuzzy filter
vim.fn['ddc#custom#patch_global']('sourceOptions', {
  _ = {
    ignoreCase = true,
    matchers = {'matcher_fuzzy'},
    sorters = {'sorter_fuzzy'},
    converters = {'converter_fuzzy'},
    },
  })

-- Editor completion source options.
vim.fn['ddc#custom#patch_global']('sourceOptions', {
  around = {mark = 'A'},
  buffer = {mark = 'B'},
  file = {
    mark = 'F',
    isVolatile = true,
    minAutoCompleteLength = 1000,
    forceCompletionPattern = [[\S/\S*]],
    },
  vsnip = {
    mark = 'snip',
    dup = true,
    },
  ['nvim-lsp'] = {
    mark = 'LSP',
    forceCompletionPattern = [[\.\w*|:\w*|->\w*]],
    dup = 'force',
    },
  ['nvim-lua'] = {mark = 'lua'},
  necovim = {mark = 'vim'},
  rg = {
    mark = 'rg',
    minAutoCompleteLength = 5,
    },
  skkeleton = {
    mark = 'SKK',
    matchers = {'skkeleton'},
    sorters = vim.empty_dict(),
    minAutoCompleteLength = 2,
    isVolatile = true,
    },
  })

-- Commandline completion source options.
vim.fn['ddc#custom#patch_global']('sourceOptions', {
  cmdline = {
    mark = 'cmd',
    forceCompletionPattern = [[\S/\S*]],
    dup = 'force',
    },
  ['cmdline-history'] = {
    mark = 'cmd-history',
    sorters = {},
    },
  input = {
    mark = 'input',
    forceCompletionPattern = [[\S/\S*]],
    isVolatile = true,
    dup = 'force',
    },
  line = { mark = 'line', },
  ['shell-history'] = {
    mark = 'sh-history',
    },
  })

-- ddc source params
vim.fn['ddc#custom#patch_global']('sourceParams', {
  buffer = {
    requireSameFiletype = false,
    fromAltBuf = true,
    bufNameStyle = 'basename',
    },
  line = {maxSize = 500},
  ['nvim-lsp'] = {
    kindLabels = {
    --[[LSPのラベルタグの参考元:
        https://github.com/onsails/lspkind.nvim]]
      Text = [[ Text]],
      Method = [[ Method]],
      Function = [[ Function]],
      Constructor = [[ Constructor]],
      Field = [[ﰠ Field]],
      Variable = [[ Variable]],
      Class = [[ﴯ Class]],
      Interface = [[ Interface]],
      Module = [[ Module]],
      Property = [[ﰠ Property]],
      Unit = [[塞 Unit]],
      Value = [[ Value]],
      Enum = [[ Enum]],
      Keyword = [[ Keyword]],
      Snippet = [[ Snippet]],
      Color = [[ Color]],
      File = [[ File]],
      Reference = [[ Reference]],
      Folder = [[ Folder]],
      EnumMember = [[ EnumMember]],
      Constant = [[ Constant]],
      Struct = [[פּ Struct]],
      Event = [[ Event]],
      Operator = [[ Operator]],
      TypeParameter = [[TypeParameter]],
      },
    },
  })


-- filetype settings
vim.fn['ddc#custom#patch_filetype']({'python', 'php', 'yaml'}, {
  sources = vim.fn.extendnew(global_source, {'nvim-lsp'}, 0)
})

vim.fn['ddc#custom#patch_filetype']('lua', {
  sources = vim.fn.extendnew(global_source, {'nvim-lua', 'nvim-lsp'}, 0),
})

vim.fn['ddc#custom#patch_filetype']({'vim', 'toml'}, {
  sources = vim.fn.extendnew(global_source, {'necovim'}, 0),
})

vim.fn['ddc#custom#patch_filetype']({'ddu-ff-filter'}, {
  keywordPattern = [=[[0-9a-zA-Z_:#-]*]=],
  sources = {'line', 'buffer'},
  specialBufferCompletion = true,
})

vim.fn['ddc#custom#patch_filetype']({'deol'}, {
  keywordPattern = [[\w*]],
  sources = {'shell-history'},
  specialBufferCompletion = true,
  sourceOptions = {
    matchers = {'matcher_head'},
    sorters = {'sorter_rank'},
  },
})

---ddc手動補完のソース指定を楽チンにするやつ
-- https://github.com/4513ECHO/dotfiles/blob/73f2f46/config/nvim/dein/settings/ddc.vim#L163-L175
---@param ... string ddc-source name
local ddc_complete = function(...)
  vim.fn['ddc#map#manual_complete']({ sources = {...} })
end

-- Keymaping
-- Insert-Mode
local expr_opt = { expr = true, noremap = true }
local opt = { noremap = true, silent = true }
require('user.utils').keymaps_set{
  {
    mode = {"i", "c"},
    lhs = [[<C-n>]],
    rhs = function()
      if vim.fn['pum#visible']() then
        vim.fn['pum#map#select_relative'](1)
      else
        return [[<Down>]]
      end
    end,
    opts = expr_opt,
  },
  {
    mode = {"i", "c"},
    lhs = [[<C-p>]],
    rhs = function()
      if vim.fn['pum#visible']() then
        vim.fn['pum#map#select_relative'](-1)
      else
        return [[<Up>]]
      end
    end,
    opts = expr_opt,
  },
  {
    mode = "i",
    lhs = [[<CR>]],
    rhs = function()
      if vim.fn['pum#visible']() then
        vim.fn['pum#map#confirm']()
      else
        return vim.fn['lexima#expand']('<lt>CR>', 'i')
      end
    end,
    opts = expr_opt,
  },
  {
    mode = "i",
    lhs = [[<BS>]],
    rhs = function()
      if vim.fn['pum#visible']() then
        vim.fn['pum#map#cancel']()
      else
        return vim.fn['lexima#expand']('<lt>BS>', 'i')
      end
    end,
    opts = expr_opt,
  },
  {
    mode = "c",
    lhs = [[<CR>]],
    rhs = function()
      if vim.fn['pum#visible']() then
        vim.fn['pum#map#confirm']()
      else
        return [[<Plug>(kensaku-search-replace)<CR>]]
      end
    end,
    opts = expr_opt,
  },
  {
    mode = "c",
    lhs = [[<BS>]],
    rhs = function()
      if vim.fn['pum#visible']() then
        vim.fn['pum#map#cancel']()
      else
        return [[<BS>]]
      end
    end,
    opts = expr_opt,
  },
  {
    mode = "i",
    lhs = [[<C-x><C-l>]],
    rhs = function()
      ddc_complete('line')
    end,
    opts = opt,
  },
  {
    mode = "i",
    lhs = [[<C-x><C-n>]],
    rhs = function()
      ddc_complete('around', 'buffer', 'rg')
    end,
    opts = opt,
  },
  {
    mode = "i",
    lhs = [[<C-x><C-f>]],
    rhs = function()
      ddc_complete('file')
    end,
    opts = opt,
  },
  {
    mode = "i",
    lhs = [[<C-x><C-d>]],
    rhs = function()
      ddc_complete('nvim-lsp')
    end,
    opts = opt,
  },
  {
    mode = "i",
    lhs = [[<C-x><C-v>]],
    rhs = function()
      ddc_complete('necovim', 'nvim-lua', 'cmdline')
    end,
    opts = opt,
  },
  {
    mode = "i",
    lhs = [[<C-x><C-s>]],
    rhs = function()
      ddc_complete('vsnip')
    end,
    opts = opt,
  },
  {
    mode = "i",
    lhs = [[<C-x><C-u>]],
    rhs = function()
      vim.fn['ddc#map#manual_complete']()
    end,
    opts = opt,
  },
}

vim.fn['ddc#enable']()
-- }}}
