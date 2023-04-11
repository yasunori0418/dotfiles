" hook_add {{{
" keybinds into cmdline mode
nnoremap : <Cmd>call vimrc#commandline_pre(':')<CR>:
xnoremap : <Cmd>call vimrc#commandline_pre(':')<CR>:

nnoremap / <Cmd>call vimrc#commandline_pre('/')<CR>/
nnoremap ? <Cmd>call vimrc#commandline_pre('?')<CR>?
" }}}

" hook_source {{{
" UI settings

" Use pum.vim
call ddc#custom#patch_global('autoCompleteEvents', [
  \ 'InsertEnter', 'TextChangedI', 'TextChangedP',
  \ 'CmdlineEnter', 'CmdlineChanged', 'TextChangedT',
  \ ])

call ddc#custom#patch_global('ui', 'pum')

" Filter settings
" Normal filter
"call ddc#custom#patch_global('sourceOptions', #{
"  \ _: #{
"    \ ignoreCase: v:true,
"    \ matchers: ['matcher_head', 'matcher_length'],
"    \ sorters: ['sorter_rank'],
"    \ converters: ['converter_remove_overlap'],
"    \ },
"  \ })

" Fuzzy filter
call ddc#custom#patch_global('sourceOptions', #{
  \ _: #{
    \ ignoreCase: v:true,
    \ matchers: ['matcher_fuzzy'],
    \ sorters: ['sorter_fuzzy'],
    \ converters: ['converter_fuzzy'],
    \ },
  \ })

" Source options.
call ddc#custom#patch_global('sources', ['vsnip', 'around', 'file', 'rg'])

call ddc#custom#patch_global('cmdlineSources', {
  \ ':': ['cmdline', 'cmdline-history', 'around'],
  \ '@': ['cmdline-history', 'input', 'file', 'around'],
  \ '>': ['cmdline-history', 'input', 'file', 'around'],
  \ '/': ['around', 'line'],
  \ '?': ['around', 'line'],
  \ '-': ['around', 'line'],
  \ '=': ['input'],
  \ })

" Editor completion source options.
call ddc#custom#patch_global('sourceOptions', #{
  \ around: #{mark: 'A'},
  \ buffer: #{mark: 'B'},
  \ file: #{
    \ mark: 'F',
    \ isVolatile: v:true,
    \ minAutoCompleteLength: 1000,
    \ forceCompletionPattern: '\S/\S*',
    \ },
  \ vsnip: #{
    \ mark: 'snip',
    \ dup: v:true,
    \ },
  \ nvim-lsp: #{
    \ mark: 'LSP',
    \ forceCompletionPattern: '\.\w*|:\w*|->\w*',
    \ dup: 'force',
    \ },
  \ nvim-lua: #{mark: 'lua'},
  \ necovim: #{mark: 'vim'},
  \ rg: #{
    \ mark: 'rg',
    \ minAutoCompleteLength: 5,
    \ },
  \ skkeleton: #{
    \ mark: 'SKK',
    \ matchers: ['skkeleton'],
    \ sorters: [],
    \ minAutoCompleteLength: 2,
    \ isVolatile: v:true,
    \ },
  \ })

" Commandline completion source options.
call ddc#custom#patch_global('sourceOptions', #{
  \ cmdline: #{
    \ mark: 'cmd',
    \ forceCompletionPattern: '\S/\S*',
    \ dup: 'force',
    \ },
  \ cmdline-history: #{
    \ mark: 'cmd-history',
    \ sorters: [],
    \ },
  \ input: #{
    \ mark: 'input',
    \ forceCompletionPattern: '\S/\S*',
    \ isVolatile: v:true,
    \ dup: 'force',
    \ },
  \ line: #{ mark: 'line', },
  \ shell-history: #{
    \ mark: 'sh-history',
    \ },
  \ })

" ddc source params
call ddc#custom#patch_global('sourceParams', #{
  \ buffer: #{
    \ requireSameFiletype: v:false,
    \ fromAltBuf: v:true,
    \ bufNameStyle: 'basename',
    \ },
  \ line: #{maxSize: 500},
  \ nvim-lsp: #{
    \ kindLabels: #{
      \ Text: ' Text',
      \ Method: ' Method',
      \ Function: ' Function',
      \ Constructor: ' Constructor',
      \ Field: 'ﰠ Field',
      \ Variable: ' Variable',
      \ Class: 'ﴯ Class',
      \ Interface: ' Interface',
      \ Module: ' Module',
      \ Property: 'ﰠ Property',
      \ Unit: '塞 Unit',
      \ Value: ' Value',
      \ Enum: ' Enum',
      \ Keyword: ' Keyword',
      \ Snippet: ' Snippet',
      \ Color: ' Color',
      \ File: ' File',
      \ Reference: ' Reference',
      \ Folder: ' Folder',
      \ EnumMember: ' EnumMember',
      \ Constant: ' Constant',
      \ Struct: 'פּ Struct',
      \ Event: ' Event',
      \ Operator: ' Operator',
      \ TypeParameter: 'TypeParameter',
      \ },
    \ },
  \ })
" LSPのラベルタグの参考元: https://github.com/onsails/lspkind.nvim


" filetype settings
call ddc#custom#patch_filetype(['python', 'php', 'yaml'], 'sources',
  \ ['nvim-lsp', 'vsnip', 'around', 'file', 'rg'],
  \ )

call ddc#custom#patch_filetype('lua', 'sources',
  \ ['nvim-lsp', 'nvim-lua', 'around', 'file', 'rg'],
  \ )

call ddc#custom#patch_filetype(['vim', 'toml'], 'sources',
  \ ['necovim', 'vsnip', 'around', 'file', 'rg'],
  \ )

call ddc#custom#patch_filetype(['ddu-ff-filter'], #{
  \ keywordPattern: '[0-9a-zA-Z_:#-]*',
  \ sources: ['line', 'buffer'],
  \ specialBufferCompletion: v:true,
  \ })

call ddc#custom#patch_filetype(['deol'], #{
  \ sources: ['shell-history'],
  \ specialBufferCompletion: v:true,
  \ })

" Keymaping
" Insert-Mode
inoremap <expr>   <TAB>
  \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
  \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
  \ '<TAB>' : ddc#map#manual_complete()
inoremap <S-TAB>  <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-n>    <Cmd>call pum#map#select_relative(+1)<CR>
inoremap <C-p>    <Cmd>call pum#map#select_relative(-1)<CR>

inoremap <C-y>    <Cmd>call pum#map#confirm()<CR>
inoremap <expr>   <C-e>
  \ pum#visible() ? '<Cmd>call pum#map#cancel()<CR>' : '<C-o>$'

" Cmdline-Mode
cnoremap <expr>   <TAB>
  \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
  \ exists('b:prev_buffer_config') ?
  \ ddc#map#manual_complete() : nr2char(&wildcharm)
cnoremap <S-TAB>  <Cmd>call pum#map#insert_relative(-1)<CR>

cnoremap <expr>   <C-n>
  \ pum#visible() ? '<Cmd>call pum#map#select_relative(+1)<CR>' : '<C-n>'
cnoremap <expr>   <C-p>
\ pum#visible() ? '<Cmd>call pum#map#select_relative(-1)<CR>' : '<C-p>'

cnoremap <C-y>    <Cmd>call pum#map#confirm()<CR>
cnoremap <silent><expr> <C-e>
  \ pum#visible() ? '<Cmd>call pum#map#cancel()<CR>' : '<END>'


call ddc#enable()
" }}}
