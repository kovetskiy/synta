let g:go_list_type = "quickfix"

func! synta#quickfix#reset()
    let g:synta_quickfix_nr = 0
    let g:synta_quickfix_count = len(getqflist())
endfunc!

func! synta#quickfix#error()
    echo getqflist()[g:synta_quickfix_nr]["text"]
endfunc!

func! synta#quickfix#counter()
    return "[" . (g:synta_quickfix_nr+1) . "/" . g:synta_quickfix_count . "]"
endfunc!

func! synta#quickfix#go(nr)
    let item = getqflist()[a:nr]
    let buffer = item["bufnr"]
    let windows = win_findbuf(buffer)

    if len(windows) > 0
        call win_gotoid(windows[0])
    else
        execute "botright" "sbuffer" buffer
        execute "wincmd" "="
    endif

    execute "normal! " item["lnum"] . "G"
    silent! normal! zvzz

    redraw!

    let g:synta_error_current = item["text"]

    echo strpart(synta#quickfix#counter() . " " . item["text"], 0, &columns-1)

    py import vim
    py synta.try_jump_to_error_identifier(vim.vars["synta_error_current"])
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
