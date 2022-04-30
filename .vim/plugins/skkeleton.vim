function! s:skkeleton_init() abort
    " Load merged dictionary.
    call skkeleton#config({
        \ 'eggLikeNewline': v:true,
        \ 'userJisyo': '~/.skk/skkeleton/skkeleton'
        \ })

    call skkeleton#register_kanatable('rom', {
        \ 'jj': 'escape',
        \ "z\<Space>": ["\u3000", ''],
        \ '~': ['～', ''],
        \ 'z0': ["\u25CB", ''],
        \ })

        " \ 'la': ['ぁ', ''],
        " \ 'li': ['ぃ', ''],
        " \ 'lu': ['ぅ', ''],
        " \ 'le': ['ぇ', ''],
        " \ 'lo': ['ぉ', ''],
        " \ 'll': ['っ', 'l'],
        " \ 'ltu': ['っ', ''],
        " \ 'ltsu': ['っ', ''],
        " \ 'lwa': ['ゎ', ''],
        " \ 'lwe': ['ゑ', ''],
        " \ 'lwi': ['ゐ', ''],
        " \ 'lya': ['ゃ', ''],
        " \ 'lyo': ['ょ', ''],
        " \ 'lyu': ['ゅ', ''],

    " call skkeleton#register_kanatable('rom', s:disable_l())

    " call skkeleton#register_keymap('input', "x", 'disable')
endfunction

function! s:disable_l() abort

    let s:disable_l_nexts = split('bcdfghjkmnpqrsvxzBCDFGHJKMNPQRSVXZ,./1234567890-+=`~;:[]{}()<>!@#$%^&*_\"', '\zs')
    call add(s:disable_l_nexts, "'")
    call map(s:disable_l_nexts, {_, val -> 'l' .. val})

    let l:disable_l_dict = {}

    for l:disable_l_next in s:disable_l_nexts
        let l:disable_l_dict[l:disable_l_next] = ['', '']
    endfor

    return l:disable_l_dict

endfunction

function! s:skkeleton_pre() abort
    " Overwrite sources
    let s:prev_buffer_config = ddc#custom#get_buffer()
    call ddc#custom#patch_buffer('sources', ['skkeleton'])
endfunction

function! s:skkeleton_post() abort
    " Restore sources
    call ddc#custom#set_buffer(s:prev_buffer_config)
endfunction

autocmd User skkeleton-initialize-pre call s:skkeleton_init()
autocmd User skkeleton-enable-pre call s:skkeleton_pre()
autocmd User skkeleton-disable-pre call s:skkeleton_post()
