func! synta#go#build(...)
    if a:0 > 0 && a:1 != 0
        normal :w
    endif

    let g:go_errors = []

    " this will call python function which will start thread and then in main
    " thread synta#go#process_build_result will be called
    py3 synta.build()
endfunc!

func! synta#go#process_build_result(result)
    let g:errors = synta#go#parse_errors(a:result)

    call setqflist(g:errors)

    call synta#quickfix#reset()
    if len(g:errors) > 0
        call synta#quickfix#go(0)
    else
        redraw!
        call synta#success("GO")
    endif
endfunc!

function! synta#go#parse_errors(lines) abort
    let errors = []

    for line in a:lines
        let fatalerrors = matchlist(line, '^\(fatal error:.*\)$')
        let tokens = matchlist(line, '^\s*\(.*\):\(\d\+\):\d\+:\s*\(.*\)$')

        if len(tokens) >= 2 && tokens[1] =~ "^# "
            continue
        endif

        if !empty(fatalerrors)
            call add(errors, {"text": fatalerrors[1]})
        elseif !empty(tokens)
            " strip endlines of form ^M
            let out = substitute(tokens[3], '\r$', '', '')

            call add(errors, {
                    \ "filename" : fnamemodify(tokens[1], ':p'),
                    \ "lnum"     : tokens[2],
                    \ "text"     : out,
                    \ })
        elseif !empty(errors)
            " Preserve indented lines.
            " This comes up especially with multi-line test output.
            if match(line, '^\s') >= 0
                call add(errors, {"text": line})
            endif
        endif
    endfor

    if empty(errors) && !empty(a:lines)
        let err = join(a:lines, "\n")
        if !empty(err)
            call add(errors, {"text": err})
        endif
    endif

    return errors
endfunction
