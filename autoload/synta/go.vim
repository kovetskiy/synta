func! synta#go#build(...)
    if a:0 > 0 && a:1 != 0
        normal :w
    endif

    let g:go_errors = []

    py synta.build()

    let g:errors = go#tool#ParseErrors(g:go_errors)

    call setqflist(g:errors)

    call synta#quickfix#reset()
    if len(g:errors) > 0
        call synta#quickfix#go(0)
    else
        redraw!
        echohl String
        echon "[go] build succeed"
    endif
    echohl Normal
endfunc!
