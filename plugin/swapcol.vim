" swapcol.vim: Swap two columns 
" Last Change: 2011-08-25 
" Maintainer:  Tian Huixiong: <nedzqbear@gmail.com>
" Licence:     This script is released under the Vim License.
" Install:     
"     Put this file in ~/.vim/plugin on Linux
"     Or put it in $vim/vimfiles/plugin on Windows
" Mappings:
"   --NORMAL MODE--:
"         [c  swap current column with before
"         ]c  swap current column with behind
" Tutorial:
"         Swap columns, the columns are separated by blank.
"         Column maybe is word, or maybe not:
"               \s, list[2]; dict[3]. (example), ^\s*$ 
"               col1 col2 col3 col4 col5
"
"         1. Move cursor on col1, and press ]c, you will see:
"            col2 col1 col3 col4 col5
"
"         2. Move cursor on col4, and press [c, you will see:
"            col2 col1 col4 col3 col5
"
"         3. Move cousor on column, means you can put cursor on any character
"            of the column, not limit the first character.
"
"         4. If you don't like the default map, just modify the source.
"            The map is on the bottom.
"

if exists("g:loaded_swapcol")
    finish
endif
let g:loaded_swapcol = 1


function! GetToken(list, i, pat)
    let l:token = a:list[a:i] 
    let l:len   = len(a:list)
    let l:inx   = a:i + 1

    while l:inx < l:len
        if a:list[l:inx] =~# a:pat
            let l:token .= a:list[l:inx]
            let l:inx += 1
        else
            return l:token
        endif
    endwhile

    return l:token
endfunction

" one two three four five
" Swap current column with behind
function! SwapColWithBehind()
    let l:line   = getline('.')
    let l:list   = []
    let l:len    = strlen(line)
    let l:i      = 0
    let l:result = ''
    let l:colist = []

    while l:i < l:len
        call add(list, strpart(line, i, 1))
        let l:i += 1
    endwhile
     
    let l:i   = 0
    let l:len = len(l:list)
    while l:i < l:len
        if l:list[l:i] =~ '\s'
            let l:token = GetToken(l:list, l:i, '\s')
        else
            let l:token = GetToken(l:list, l:i, '\S')
        endif
        call add(l:colist, l:token)
        let l:i += strlen(l:token)
    endwhile
    unlet l:list
    unlet l:line

    let l:col = col('.')
    let l:pos = 1
    let l:i   = 0
    let l:len = len(l:colist)
    while l:i < l:len
        if l:col >= l:pos && l:col <= (l:pos + strlen(l:colist[l:i]) - 1)
            let l:colInx = l:i
            break
        endif
        let l:pos += strlen(l:colist[l:i])
        let l:i += 1
    endwhile
    unlet l:pos

    " The blank col
    if l:colist[l:colInx] =~# '\s'
        return
    endif
    " The last col
    if l:colInx == l:len - 1 
        return
    endif
    " No col behind
    if l:colInx + 2 >= l:len
        return
    endif

    let l:coltmp             = l:colist[l:colInx]
    let l:colist[l:colInx]   = l:colist[l:colInx+2]
    let l:colist[l:colInx+2] = l:coltmp

    let l:i   = 0
    let l:len = len(l:colist)
    while l:i < l:len
        let l:result .= l:colist[l:i]
        let l:i += 1
    endwhile
    call setline(line('.'), l:result)

endfunction

" one two three four five
" Swap current column with before
function! SwapColWithBefore()
    let l:line   = getline('.')
    let l:list   = []
    let l:len    = strlen(line)
    let l:i      = 0
    let l:result = ''
    let l:colist = []

    while l:i < l:len
        call add(list, strpart(line, i, 1))
        let l:i += 1
    endwhile
     
    let l:i   = 0
    let l:len = len(l:list)
    while l:i < l:len
        if l:list[l:i] =~ '\s'
            let l:token = GetToken(l:list, l:i, '\s')
        else
            let l:token = GetToken(l:list, l:i, '\S')
        endif
        call add(l:colist, l:token)
        let l:i += strlen(l:token)
    endwhile
    unlet l:list
    unlet l:line

    let l:col = col('.')
    let l:pos = 1
    let l:i   = 0
    let l:len = len(l:colist)
    while l:i < l:len
        if l:col >= l:pos && l:col <= (l:pos + strlen(l:colist[l:i]) - 1)
            let l:colInx = l:i
            break
        endif
        let l:pos += strlen(l:colist[l:i])
        let l:i += 1
    endwhile
    unlet l:pos

    " The blank col
    if l:colist[l:colInx] =~# '\s'
        return
    endif
    " The first col
    if l:colInx == 0 
        return
    endif
    " No col before
    if l:colInx - 2 < 0
        return
    endif

    let l:coltmp             = l:colist[l:colInx]
    let l:colist[l:colInx]   = l:colist[l:colInx-2]
    let l:colist[l:colInx-2] = l:coltmp

    let l:i   = 0
    let l:len = len(l:colist)
    while l:i < l:len
        let l:result .= l:colist[l:i]
        let l:i += 1
    endwhile
    call setline(line('.'), l:result)

endfunction

" --------------- The key map -------------------
"
" Swap current column with before
nnoremap <silent>[c :call SwapColWithBefore()<cr>

" Swap current column with behind
nnoremap <silent>]c :call SwapColWithBehind()<cr>
