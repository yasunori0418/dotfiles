" hook_add {{{
" fuzzy finder start keybinds
nmap <Space>d <Plug>(ddu-ff)

nmap <Plug>(ddu-ff)a <Cmd>call ddu#start({
  \ 'name': 'current-ff',
  \ 'sourceOptions': {
    \ 'file_rec': {'path': vimrc#search_repo_root()},
    \ },
  \ })<CR>

nmap <Plug>(ddu-ff)d <Cmd>call ddu#start(#{name: 'dotfiles-ff'})<CR>
nmap <Plug>(ddu-ff)h <Cmd>call ddu#start(#{name: 'help-ff'})<CR>
nmap <Plug>(ddu-ff)b <Cmd>call ddu#start(#{name: 'buffer-ff'})<CR>
nmap <Plug>(ddu-ff)P <Cmd>call ddu#start(#{name: 'plugin-list-ff'})<CR>
nmap <Plug>(ddu-ff)p <Cmd>call ddu#start(#{name: 'project-list-ff'})<CR>
nmap <Plug>(ddu-ff)~ <Cmd>call ddu#start(#{name: 'home-ff'})<CR>
nmap <Plug>(ddu-ff)r <Cmd>call ddu#start(#{name: 'register-ff'})<CR>
nmap <Plug>(ddu-ff)s <Cmd>call ddu#start(#{name: 'search-ff'})<CR>
nmap <Plug>(ddu-ff)m <Cmd>call ddu#start(#{name: 'mrr-ff'})<CR>
nmap <Plug>(ddu-ff)n <Cmd>call ddu#start(#{name: 'mru-ff'})<CR>
nmap <Plug>(ddu-ff)C <Cmd>call ddu#start(#{name: 'highlight-ff'})<CR>


" filer start keybins
nmap <Space>f <Plug>(ddu-filer)
nmap <Plug>(ddu-filer)a <Cmd>call ddu#start(#{
  \ name: 'project_root-filer',
  \ sourceOptions: #{
    \ file: #{path: vimrc#search_repo_root()},
    \ },
  \ })<CR>
nmap <Plug>(ddu-filer)f <Cmd>call ddu#start(#{
  \ name: 'current-filer', 
  \ sourceOptions: #{
    \ file: #{path: expand('%:p:h')},
    \ },
  \ })<CR>
nmap <Plug>(ddu-filer)d <Cmd>call ddu#start(#{name: 'dotfiles-filer'})<CR>
nmap <Plug>(ddu-filer)h <Cmd>call ddu#start(#{name: 'home-filer'})<CR>
" }}}

" hook_source {{{
" Global option and param
call ddu#custom#patch_global(#{
  \ uiOptions: #{
    \ filer: #{
      \ toggle: v:true,
      \ },
    \ },
  \ uiParams: #{
    \ ff: #{
      \ split: 'floating',
      \ floatingBorder: 'single',
      \ prompt: '',
      \ filterSplitDirection: 'floating',
      \ filterFloatingPosition: 'top',
      \ displaySourceName: 'long',
      \ previewFloating: v:true,
      \ previewFloatingBorder: 'double',
      \ previewSplit: 'horizontal',
      \ },
    \ filer: #{
      \ split: 'vertical',
      \ splitDirection: 'topleft',
      \ winWidth: &columns /6,
      \ previewFloating: v:true,
      \ previewFloatingBorder: 'double',
      \ previewCol: &columns / 4,
      \ previewRow: &lines / 2,
      \ previewWidth: &columns / 2,
      \ previewHeight: 20,
      \ },
    \ },
  \ sourceOptions: #{
    \ _: #{
      \ ignoreCase: v:true,
      \ matchers: ['matcher_substring'],
      \ },
    \ file: #{
      \ columns: ['icon_filename'],
      \ },
    \ dein: #{
      \ defaultAction: 'cd',
      \ },
    \ help: #{
      \ defaultAction: 'open',
      \ },
    \ },
  \ sourceParams: #{
    \ dein_update: #{
      \ useGraphQL: v:true,
      \ },
    \ marks: #{
      \ jumps: v:true,
      \ },
    \ rg: #{
      \ args: ['--json', '--ignore-case', '--column', '--no-heading', '--color', 'never'],
      \ highlights: #{
        \ word: 'Title',
        \},
      \ },
    \ },
  \ kindOptions: #{
    \ file: #{
      \ defaultAction: 'open',
      \ },
    \ action: #{
      \ defaultAction: 'do',
      \ },
    \ word: #{
      \ defaultAction: 'append',
      \ },
    \ deol: #{
      \ defaultAction: 'switch',
      \ },
    \ readme_viewer: #{
      \ defaultAction: 'open',
      \ },
    \ },
  \ actionOptions: #{
    \ narrow: #{quit: v:false},
    \ echo: #{quit: v:false},
    \ echoDiff: #{quit: v:false},
    \ },
  \ columnParams: #{
    \ icon_filename: #{
      \ span: 2,
      \ iconWidth: 2,
      \ defaultIcon: #{
        \ icon: '',
        \ },
      \ },
    \ },
  \ })


" UI:ff presets
call ddu#custom#patch_local('current-ff', #{
  \ ui: 'ff',
  \ uiParams: #{
    \ ff: #{
      \ startFilter: v:true,
      \ },
    \ },
  \ sources: [#{name: 'file_rec'}],
  \ })

call ddu#custom#patch_local('dotfiles-ff', #{
  \ ui: 'ff',
  \ uiParams: #{
    \ ff: #{
    \ startFilter: v:true,
    \ },
  \ },
  \ sourceOptions: #{
    \ file_rec: #{path: expand('~/dotfiles')},
    \ },
  \ sources: [#{name: 'file_rec'}],
  \ })

call ddu#custom#patch_local('project-list-ff', #{
  \ ui: 'ff',
  \ uiParams: #{
    \ ff: #{
    \ startFilter: v:true,
    \ },
  \ },
  \ sourceOptions: #{
    \ file: #{path: expand('~/Project')},
    \ },
  \ sources: [#{name: 'file'}],
  \ })

call ddu#custom#patch_local('help-ff', #{
  \ ui: 'ff',
  \ uiParams: #{
    \ ff: #{
      \ startFilter: v:true,
      \ },
    \ },
  \ sources: [
    \ #{name: 'help'},
    \ #{name: 'readme_viewer'},
    \ ],
  \ })

call ddu#custom#patch_local('search-ff', #{
  \ ui: 'ff',
  \ uiParams: #{
    \ ff: #{
      \ autoAction: #{
        \ delay: 0,
        \ name: 'preview',
        \ },
      \ winRow: &lines / 4 - 10,
      \ previewRow: &lines - 4,
      \ previewHeight: 24,
      \ ignoreEmpty: v:false,
      \ autoResize: v:false,
      \ startFilter: v:true,
      \ },
    \ },
  \ sources: [#{
    \ name: 'rg',
    \ options: #{
      \ matchers: [],
      \ volatile: v:true,
      \ },
    \ }],
  \ })

call ddu#custom#patch_local('buffer-ff', #{
  \ ui: 'ff',
  \ sources: [#{name: 'buffer'}],
  \ })

call ddu#custom#patch_local('plugin-list-ff', #{
  \ ui: 'ff',
  \ uiParams: #{
    \ ff: #{
    \ startFilter: v:true,
    \ }
  \ },
  \ sources: [#{name: 'dein'}],
  \ })

call ddu#custom#patch_local('home-ff', #{
  \ ui: 'ff',
  \ uiParams: #{
    \ ff: #{
    \ startFilter: v:true,
    \ },
  \ },
  \ sourceOptions: #{
    \ file: #{path: expand('~')},
    \ },
  \ sources: [#{name: 'file'}],
  \ })

call ddu#custom#patch_local('register-ff', #{
  \ ui: 'ff',
  \ sources: [#{name: 'register'}],
  \ })

call ddu#custom#patch_local('mrr-ff', #{
  \ ui: 'ff',
  \ uiParams: #{
    \ ff: #{
      \ startFilter: v:true,
      \ },
    \ },
  \ sources: [#{
    \ name: 'mr',
    \ params: #{
      \ kind: 'mrr',
      \ current: v:false,
      \ },
    \ }],
  \ })

call ddu#custom#patch_local('mru-ff', #{
  \ ui: 'ff',
  \ uiParams: #{
    \ ff: #{
      \ startFilter: v:true,
      \ },
    \ },
  \ sources: [#{
    \ name: 'mr',
    \ params: #{
      \ kind: 'mru',
      \ current: v:true,
      \ },
    \ }],
  \ })

call ddu#custom#patch_local('highlight-ff', #{
  \ ui: 'ff',
  \ uiParams: #{
    \ ff: #{
      \ startFilter: v:true,
      \ },
    \ },
  \ sources: [#{name: 'highlight'}],
  \ })


" UI:filer presets
call ddu#custom#patch_local('current-filer', #{
  \ ui: 'filer',
  \ sources: [#{name: 'file'}],
  \ })

call ddu#custom#patch_local('project_root-filer', #{
  \ ui: 'filer',
  \ sources: [#{name: 'file'}],
  \ })

call ddu#custom#patch_local('dotfiles-filer', #{
  \ ui: 'filer',
  \ sources: [#{name: 'file'}],
  \ sourceOptions: #{
    \ file: #{
      \ path: expand('~/dotfiles'),
      \ },
    \ },
  \ })

call ddu#custom#patch_local('home-filer', #{
  \ ui: 'filer',
  \ sources: [#{name: 'file'}],
  \ sourceOptions: #{
    \ file: #{
      \ path: expand('~'),
      \ },
    \ },
  \ })

" }}}
