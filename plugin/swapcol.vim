" swapcol.vim: Swap two columns ( on one line or multiple lines )
" Last Change: 2011-08-26 
" Maintainer:  Tian Huixiong: <nedzqbear@gmail.com>
" Licence:     This script is released under the Vim License.
" Version:     2.1
" Install:     
"         Put this file in ~/.vim/plugin on Linux
"         Or put it in $vim/vimfiles/plugin on Windows
" Mappings:
"   --NORMAL MODE--:
"         [c  swap current column with before
"         ]c  swap current column with behind
" Tutorial:
"         Swap columns, the columns are separated by blank.
"         Column maybe is word, or maybe not:
"            \s,  list[2];  dict[3].  (example),  ^\s*$ 
"            col1   col2   col3   col4   col5
"
"         1. Move cursor on col1, and press ]c, you will see:
"            col2   col1   col3   col4   col5
"
"         2. Move cursor on col4, and press [c, you will see:
"            col2   col1   col4   col3   col5
"
"         3. Move cousor on column, means you can put cursor on any character
"            of the column, not limit the first character.
"
"         4. If you don't like the default map, just modify the source.
"            The map code is on the bottom.
"
"         5. You can swap columns on multiple lines. 
"            Swap column 1 and column 3 on 5 lines.
"
"            111  222  333  444  555      333  222  111  444  555
"            111  222  333  444  555      333  222  111  444  555
"            111  222  333  444  555 ---> 333  222  111  444  555
"            111  222  333  444  555      333  222  111  444  555
"            111  222  333  444  555      333  222  111  444  555
"
"            Step 1: select multiple lines in visual mode
"                    press V (upper case)
"                    and then use j or k to select lines
"            Step 2: call function SwapCols(), like:
"                    :'<,'>call SwapCols(1,3)  
"                    When you press : , '<,'> will come out automatically.
"            Setp 3: press Enter to continue, and you will get the result.
"            
"            Remember: the first column is column 1, not 0.


if exists("g:loaded_swapcol")
    finish
endif
let g:loaded_swapcol = 1

function! GetToken(line, i, pat)
    let l:token = strpart(a:line, a:i, 1) 
    let l:len   = strlen(a:line)
    let l:inx   = a:i + 1

    while l:inx < l:len
        let l:char = strpart(a:line, l:inx, 1)
        if l:char =~# a:pat
            let l:token .= l:char
            let l:inx += 1
        else
            return l:token
        endif
    endwhile

    return l:token
endfunction

" Swap current column with behind
function! SwapColWithBehind()
    let l:line = getline('.')
    let l:len  = strlen(l:line)
    let l:col  = col('.')
    let l:i    = 0
    let l:list = []

    while l:i < l:len
        if strpart(l:line, l:i, 1) =~ '\s'
            let l:token = GetToken(l:line, l:i, '\s')
        else
            let l:token = GetToken(l:line, l:i, '\S')
        endif
        call add(l:list, l:token)
        let l:i += strlen(l:token)
    endwhile
    unlet l:line

    let l:pos = 1
    let l:i   = 0
    let l:len = len(l:list)
    while l:i < l:len
        if l:col >= l:pos && l:col <= (l:pos + strlen(l:list[l:i]) - 1)
            let l:cur = l:i
            break
        endif
        let l:pos += strlen(l:list[l:i])
        let l:i   += 1
    endwhile
    unlet l:pos

    " The blank col
    if l:list[l:cur] =~# '\s'
        return
    endif
    " The last col
    if l:cur == l:len - 1 
        return
    endif
    " No col behind
    let l:swap = l:cur + 2
    if l:swap >= l:len
        return
    endif

    let l:coltmp       = l:list[l:cur]
    let l:list[l:cur]  = l:list[l:swap]
    let l:list[l:swap] = l:coltmp

    call setline(line('.'), join(l:list, ''))
endfunction

" Swap current column with before
function! SwapColWithBefore()
    let l:line = getline('.')
    let l:col  = col('.')
    let l:len  = strlen(l:line)
    let l:i    = 0
    let l:list = []

    while l:i < l:len
        if strpart(l:line, l:i, 1) =~ '\s'
            let l:token = GetToken(l:line, l:i, '\s')
        else
            let l:token = GetToken(l:line, l:i, '\S')
        endif
        call add(l:list, l:token)
        let l:i += strlen(l:token)
    endwhile
    unlet l:line

    let l:pos = 1
    let l:i   = 0
    let l:len = len(l:list)
    while l:i < l:len
        if l:col >= l:pos && l:col <= (l:pos + strlen(l:list[l:i]) - 1)
            let l:cur = l:i
            break
        endif
        let l:pos += strlen(l:list[l:i])
        let l:i   += 1
    endwhile
    unlet l:pos

    " The blank col
    if l:list[l:cur] =~# '\s'
        return
    endif
    " The first col
    if l:cur == 0 
        return
    endif
    " No col before
    let l:swap = l:cur - 2
    if l:swap < 0
        return
    endif

    let l:coltmp       = l:list[l:cur]
    let l:list[l:cur]  = l:list[l:swap]
    let l:list[l:swap] = l:coltmp

    call setline(line('.'), join(l:list, ''))
endfunction

" Swap two columns
function! SwapCols_(linenum, m, n)
    let l:line       = getline(a:linenum)
    let l:len        = strlen(l:line)
    let l:i          = 0
    let l:blank_list = []
    let l:col_list   = []

    while l:i < l:len
        if strpart(l:line, l:i, 1) =~ '\s'
            let l:token = GetToken(l:line, l:i, '\s')
            call add(l:blank_list, l:token)
        else
            let l:token = GetToken(l:line, l:i, '\S')
            call add(l:col_list, l:token)
        endif
        let l:i += strlen(l:token)
    endwhile
    if strpart(l:line, 0, 1) =~# '\s'
        let l:firstColIsBlank = 1
    else
        let l:firstColIsBlank = 0
    endif 
    unlet l:line

    " The column num is illegal
    if a:m <= 0 || a:m > len(l:col_list)
        return
    endif
    if a:n <= 0 || a:n > len(l:col_list)
        return
    endif
    
    let l:coltmp          = l:col_list[a:m-1]
    let l:col_list[a:m-1] = l:col_list[a:n-1]
    let l:col_list[a:n-1] = l:coltmp

    let l:first_i   = 0
    let l:second_i  = 0
    let l:result    = ''

    if l:firstColIsBlank 
        let l:first  = l:blank_list
        let l:second = l:col_list
    else
        let l:first  = l:col_list
        let l:second = l:blank_list
    endif

    let l:first_len  = len(l:first)
    let l:second_len = len(l:second)
    
    while l:first_i < l:first_len && l:second_i < l:second_len
        let l:result   .= l:first[l:first_i]
        let l:result   .= l:second[l:second_i]
        let l:first_i  += 1
        let l:second_i += 1
    endwhile
    if l:first_i < l:first_len
        let l:result .= l:first[l:first_i]
    endif
    if l:second_i < l:second_len
        let l:result .= l:second[l:second_i]
    endif
        
    call setline(a:linenum, l:result)
endfunction

" Swap two columns on multiple lines
function! SwapCols(m, n) range
    for l:linenum in range(a:firstline, a:lastline)
        call SwapCols_(l:linenum, a:m, a:n)
    endfor
endfunction

" --------------- The key map -------------------
"
" Swap current column with before
nnoremap <silent>[c :call SwapColWithBefore()<cr>

" Swap current column with behind
nnoremap <silent>]c :call SwapColWithBehind()<cr>



