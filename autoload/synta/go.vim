func! synta#go#build(...)
    if a:0 > 0 && a:1 != 0
        normal :w
        redraw!
    endif

    echohl Special
    echon "[Go] Building..."

    let g:go_errors = []

    py << CODE
import subprocess

build = subprocess.Popen(
    ["go", "build"],
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
    close_fds=True
)

_, stderr = build.communicate()
lines = stderr.split('\n')
if len(lines) > 1:
    lines = lines[1:]
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
        echon "[Go] Building done"
    endif
    echohl Normal
endfunc!
