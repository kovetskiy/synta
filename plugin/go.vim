augroup _synta_go
    au!
    au BufWritePost *.go call synta#rehighlight()
    au BufEnter     *.go call synta#highlight()
    au BufNew       *.go call synta#rehighlight()
augroup end

let s:hacks = expand('<sfile>:p:h:h') . '/vim-hacks/'

let g:hacks_directories = get(g:, "hacks_directories", [])
if type(g:hacks_directories) == type("")
    let s:hacks_directories = g:hacks_directories
    unlet g:hacks_directories
    let g:hacks_directories = [s:hacks_directories]
    unlet s:hacks_directories
endif

call add(g:hacks_directories, s:hacks)

unlet s:hacks

if !exists('g:synta_use_go_fast_build')
    let g:synta_use_go_fast_build = 1
endif

if !exists('g:synta_use_sbuffer')
    let g:synta_use_sbuffer = 1
endif

if !exists('g:synta_go_build_recursive')
    let g:synta_go_build_recursive = 1
endif
