autocmd FileType denite set winblend=30
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
    " Open to current window with Ente-key
    nnoremap <silent><buffer><expr> <CR>
    \ denite#do_map('do_action')

    " Open to current window with o-key
    nnoremap <silent><buffer><expr> o
    \ denite#do_map('do_action', 'open')
    nnoremap <silent><buffer><expr> O
    \ denite#do_map('do_action', 'switch')

    " Open to horizontal split window with s-key
    nnoremap <silent><buffer><expr> s
    \ denite#do_map('do_action', 'split')
    nnoremap <silent><buffer><expr> S
    \ denite#do_map('do_action', 'splitswitch')

    " Open to vertical split window with v-key
    nnoremap <silent><buffer><expr> v
    \ denite#do_map('do_action', 'vsplit')
    nnoremap <silent><buffer><expr> V
    \ denite#do_map('do_action', 'vsplitswitch')

    " Open to tab window with t-key
    nnoremap <silent><buffer><expr> t
    \ denite#do_map('do_action', 'tabopen')
    nnoremap <silent><buffer><expr> T
    \ denite#do_map('do_action', 'tabswitch')

    " Remove from buffer list
    nnoremap <silent><buffer><expr> d
    \ denite#do_map('do_action', 'delete')

    " Move to the upper path and restart Denite buffer.
    nnoremap <silent><buffer><expr> ..
    \ denite#do_map('move_up_path')

    " Preview using bat.
    nnoremap <silent><buffer><expr> p
    \ denite#do_map('do_action', 'preview_bat')

    " Command to close Denite buffer, ESC and q
    nnoremap <silent><buffer><expr> <ESC>
    \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> q
    \ denite#do_map('quit')

    " Switch to file search mode with i-key 
    nnoremap <silent><buffer><expr> i
    \ denite#do_map('open_filter_buffer')

    " Select multiple files with <Space>
    nnoremap <silent><buffer><expr> <Space>
    \ denite#do_map('toggle_select').'j'
endfunction


" ========  Denite menus  ========
let s:menus = {}

let s:menus.dotfiles_Vim = {
    \ 'description':        ' Edit Vim config files.'
    \ }

let s:menus.dotfiles_Vim.file_candidates = [
    \ ['init.vim',          '~/dotfiles/vim/init.vim'],
    \ ['option.rc.vim',     '~/dotfiles/vim/option.rc.vim'],
    \ ['keybind.vim',       '~/dotfiles/vim/keybind.vim'],
    \ ['denite.rc.vim',     '~/dotfiles/vim/denite.rc.vim'],
    \ ['lightline.rc.vim',  '~/dotfiles/vim/lightline.rc.vim'],
    \ ['dein.toml',         '~/dotfiles/vim/dein.toml'],
    \ ['lazy.toml',         '~/dotfiles/vim/lazy.toml'],
    \ ['filetype.toml',     '~/dotfiles/vim/filetype.toml'],
    \ ]

let s:menus.dotfiles_Alacritty = {
    \ 'description':        ' Edit alacritty config filles.'
    \ }

let s:menus.dotfiles_Alacritty.file_candidates = [
    \ ['alacritty.yml',     '~/dotfiles/alacritty/alacritty.yml'],
    \ ]

let s:menus.dotfiles_Zsh = {
    \ 'description':        ' Edit zsh config files.'
    \ }

let s:menus.dotfiles_Zsh.file_candidates = [
    \ ['zshrc',                 '~/dotfiles/.zshrc'],
    \ ['zprofile',              '~/dotfiles/.zprofile'],
    \ ['p10k config',           '~/dotfiles/.p10k.zsh'],
    \ ]

let s:menus.dotfiles_i3wm = {
    \ 'description':            'Edit i3wm config file.'
    \ }

let s:menus.dotfiles_i3wm.file_candidates = [
    \ ['i3wm config',           '~/dotfiles/i3wm/config'],
    \ ]

let s:menus.Denite_cmd= {
    \ 'description':            'Denite commands'
    \ }

let s:menus.Denite_cmd.command_candidates = [
    \ ['dein',                                  'Denite dein'],
    \ ['buffer',                                'Denite buffer'],
    \ ['register',                              'Denite register'],
    \ ['file buffer',                           'Denite file buffer'],
    \ ['help -start-filter',                    'Denite help -start-filter'],
    \ ['source denite.rc.vim',                  'source ~/dotfiles/vim/denite.rc.vim'],
    \ ['file/rec buffer -start-filter',         'Denite file/rc buffer -start-filter'],
    \ ]

" Registration of denite menu
call denite#custom#var('menu', 'menus', s:menus)

" ================================

" Change file/rec command.
call denite#custom#var('file/rec', 'command',
    \ ['rg', '--files', '--glob', '!.git', '--color', 'never'])
" Ripgrep command on grep source
call denite#custom#var('grep', {
    \ 'command': ['rg', '--threads', '1'],
    \ 'default_opts': ['--smart-case', '--vimgrep', '--no-heading'],
    \ 'recursive_opts': [],
    \ 'pattern_opt': ['--regexp'],
    \ 'separator': ['--'],
    \ 'final_opts': [],
    \ })
call denite#custom#option('_', {
    \ 'split': 'floating',
    \ 'floating_preview': v:true,
    \ 'prompt': '❯'
    \ })
