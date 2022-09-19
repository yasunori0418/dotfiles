" Neovide settings

"if exists('g:neovide')
" Font and size settings when using GUI
set guifont=Cica:h14

" East asia ambigunous width ploblem.
set ambiwidth=double

" Refresh rate
let g:neovide_refresh_rate = 60

" Always fullscreen
"let g:neovide_fullscreen = v:true

" Transparency background.
"let g:neovide_transparency = 0.8

" No idle
let g:neovide_no_idle = v:true

" Scroll animation length
let g:neovide_scroll_animation_length = 0.3

" Cursor settings{{{

" Animation length
let g:neovide_cursor_animation_length=0.1

" Animation trail length
let g:neovide_cursor_trail_length = 0.1
let g:neovide_cursor_trail_size = 0.15

" Cursor anti aliasing
let g:neovide_cursor_antialiasing = v:true

" Cursor particle
let g:neovide_cursor_vfx_mode = "pixiedust"

" }}}

let g:neovide_floating_blur_amount_x = 2.0
let g:neovide_floating_blur_amount_y = 2.0

"endif
