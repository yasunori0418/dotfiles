" hook_source {{{
" UI:ff presets
" call ddu#custom#patch_local('current-ff', #{
"   \ ui: 'ff',
"   \ uiParams: #{
"     \ ff: #{
"       \ startFilter: v:true,
"       \ },
"     \ },
"   \ sources: [#{name: 'file_rec'}],
"   \ })
"
" call ddu#custom#patch_local('dotfiles-ff', #{
"   \ ui: 'ff',
"   \ uiParams: #{
"     \ ff: #{
"     \ startFilter: v:true,
"     \ },
"   \ },
"   \ sourceOptions: #{
"     \ file_rec: #{path: expand('~/dotfiles')},
"     \ },
"   \ sources: [#{name: 'file_rec'}],
"   \ })
"
" call ddu#custom#patch_local('project-list-ff', #{
"   \ ui: 'ff',
"   \ uiParams: #{
"     \ ff: #{
"     \ startFilter: v:true,
"     \ },
"   \ },
"   \ sourceOptions: #{
"     \ file: #{path: expand('$WORKING_DIR')},
"     \ },
"   \ sources: [#{name: 'file'}],
"   \ })
"
" call ddu#custom#patch_local('help-ff', #{
"   \ ui: 'ff',
"   \ uiParams: #{
"     \ ff: #{
"       \ startFilter: v:true,
"       \ },
"     \ },
"   \ sources: [
"     \ #{name: 'help'},
"     \ #{name: 'readme_viewer'},
"     \ ],
"   \ })
"
" call ddu#custom#patch_local('search-ff', #{
"   \ ui: 'ff',
"   \ uiParams: #{
"     \ ff: #{
"       \ autoAction: #{
"         \ delay: 0,
"         \ name: 'preview',
"         \ },
"       \ winRow: &lines / 4 - 10,
"       \ previewRow: &lines - 4,
"       \ previewHeight: 24,
"       \ ignoreEmpty: v:false,
"       \ autoResize: v:false,
"       \ startFilter: v:true,
"       \ },
"     \ },
"   \ sources: [#{
"     \ name: 'rg',
"     \ options: #{
"       \ matchers: [],
"       \ volatile: v:true,
"       \ },
"     \ }],
"   \ })
"
" call ddu#custom#patch_local('buffer-ff', #{
"   \ ui: 'ff',
"   \ sources: [#{name: 'buffer'}],
"   \ })
"
" call ddu#custom#patch_local('plugin-list-ff', #{
"   \ ui: 'ff',
"   \ uiParams: #{
"     \ ff: #{
"     \ startFilter: v:true,
"     \ }
"   \ },
"   \ sources: [#{name: 'dein'}],
"   \ })
"
" call ddu#custom#patch_local('home-ff', #{
"   \ ui: 'ff',
"   \ uiParams: #{
"     \ ff: #{
"     \ startFilter: v:true,
"     \ },
"   \ },
"   \ sourceOptions: #{
"     \ file: #{path: expand('~')},
"     \ },
"   \ sources: [#{name: 'file'}],
"   \ })
"
" call ddu#custom#patch_local('register-ff', #{
"   \ ui: 'ff',
"   \ sources: [#{name: 'register'}],
"   \ })
"
" call ddu#custom#patch_local('mrr-ff', #{
"   \ ui: 'ff',
"   \ uiParams: #{
"     \ ff: #{
"       \ startFilter: v:true,
"       \ },
"     \ },
"   \ sources: [#{
"     \ name: 'mr',
"     \ params: #{
"       \ kind: 'mrr',
"       \ current: v:false,
"       \ },
"     \ }],
"   \ })
"
" call ddu#custom#patch_local('mru-ff', #{
"   \ ui: 'ff',
"   \ uiParams: #{
"     \ ff: #{
"       \ startFilter: v:true,
"       \ },
"     \ },
"   \ sources: [#{
"     \ name: 'mr',
"     \ params: #{
"       \ kind: 'mru',
"       \ current: v:true,
"       \ },
"     \ }],
"   \ })
"
" call ddu#custom#patch_local('highlight-ff', #{
"   \ ui: 'ff',
"   \ uiParams: #{
"     \ ff: #{
"       \ startFilter: v:true,
"       \ },
"     \ },
"   \ sources: [#{name: 'highlight'}],
"   \ })


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
