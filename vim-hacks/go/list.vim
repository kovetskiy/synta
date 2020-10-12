func! go#list#Window(x, ...)
    if !a:0 || a:1 == 0
        cclose
        return
    endif

    call synta#quickfix#reset()

    if len(getqflist()) <= 1
        cclose
        return
    endif
endfunc!

func! go#list#JumpToFirst(...)
    call synta#quickfix#go_first()
endfunc!
