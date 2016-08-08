func! synta#go#build(...)
    if a:0 > 0 && a:1 != 0
        normal :w
    endif

    redraw!
    echohl Special
    echon "[go] building..."

    let g:go_errors = []

    py << CODE
import subprocess

build = subprocess.Popen(
    ["go-fast-compile"],
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
    close_fds=True
)

stdout, _ = build.communicate()
lines = stdout.split('\n')
if len(lines) > 0:
    vim.vars['go_errors'] = lines
CODE

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
