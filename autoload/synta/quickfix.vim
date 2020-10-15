let g:go_list_type = "quickfix"

func! synta#quickfix#reset()
    let g:synta_quickfix_nr = 0
    let g:synta_quickfix_count = len(g:errors)
endfunc!

func! synta#quickfix#error()
    echo g:errors[g:synta_quickfix_nr]["text"]
endfunc!

func! synta#quickfix#counter()
    return "[" . (g:synta_quickfix_nr+1) . "/" . g:synta_quickfix_count . "]"
endfunc!

func! synta#quickfix#go_first()
    let current = expand('%')
    for item in g:errors
        if get(item, 'filename', '') != ''
            if item['filename'] == current
                call synta#quickfix#open(item)
                return
            endif
        endif
    endfor

    call synta#quickfix#go(0)
endfunc!

func! synta#quickfix#go(nr)
    call synta#quickfix#open(g:errors[a:nr])
endfunc!

func! synta#quickfix#open(item)
    if get(a:item, 'filename', '') != ''
        let full_filename = fnamemodify(a:item['filename'], ':p')
        let buffers = tabpagebuflist()
        let found = 0
        for bufnr in buffers
            if fnamemodify(bufname(bufnr), ':p') == full_filename
                let windows = win_findbuf(bufnr)
                if len(windows) > 0
                    echom "win_gotoid"
                    call win_gotoid(windows[0])
                    let found = 1
                    break
                endif
            endif
        endfor

        if found == 0
            echom 'vsp'
            execute 'vsp' a:item['filename']
        endif
    endif

    call synta#quickfix#navigate(a:item)
endfunc!

func! synta#quickfix#navigate(item)
    if get(a:item, 'lnum', '') != ''
        execute "normal! " a:item["lnum"] . "G"
        silent! normal! zvzz
    endif

    redraw!

    if empty(a:item["text"])
        return
    endif

    let g:synta_error_current = a:item["text"]

    echohl Error
    echo strpart(synta#quickfix#counter() . " " . a:item["text"], 0, &columns-1)
    echohl Normal

    py3 import vim
    py3 synta.try_jump_to_error_identifier(vim.vars["synta_error_current"])
endfunc!

func! synta#quickfix#next()
    let next_nr = g:synta_quickfix_nr + 1
    if next_nr < g:synta_quickfix_count
        call synta#quickfix#go(next_nr)
        let g:synta_quickfix_nr = next_nr
    else
        echo ""
    endif
endfunc!

func! synta#quickfix#prev()
    let prev_nr = g:synta_quickfix_nr - 1
    if prev_nr >= 0
        call synta#quickfix#go(prev_nr)
        let g:synta_quickfix_nr = prev_nr
    else
        echo ""
    endif
endfunc!
