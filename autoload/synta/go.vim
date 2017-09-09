func! synta#go#build(...)
    if a:0 > 0 && a:1 != 0
        normal :w
    endif

    let g:go_errors = []

    py << CODE
import subprocess

args = ["go-fast-build"]
if not vim.vars['synta_use_go_fast_build']:
    args = ["go", "build"]

build = subprocess.Popen(
    args,
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
    close_fds=True
)

lines = []

if vim.vars['synta_use_go_fast_build']:
    stdout, _ = build.communicate()
    lines = stdout.split('\n')
else:
    _, stderr = build.communicate()
    lines = stderr.split('\n')

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
