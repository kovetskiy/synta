augroup _synta_go
    au!
    au BufWritePost *.go call synta#rehighlight()
    au BufEnter     *.go call synta#highlight()
    au BufNew       *.go call synta#rehighlight()
augroup end

let s:hacks = expand('<sfile>:p:h:h') . '/vim-hacks/'

let g:hacks_directories = get(g:, "hacks_directories", [])
if type(g:hacks_directories) == type("")
    let g:hacks_directories = [g:hacks_directories]
endif

call add(g:hacks_directories, s:hacks)

unlet s:hacks
