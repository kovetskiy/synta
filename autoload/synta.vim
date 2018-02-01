py import synta

let g:synta_go_highlight_calls = get(g:, 'synta_go_highlight_calls', 1)
let g:synta_go_highlight_calls_funcs = get(g:, 'synta_go_highlight_calls_funcs', 0)

func! synta#highlight_builtins()
    syn keyword goErr err
    syn keyword goConditional case default
    syn match goFormatSpecifier   /%[-#0 +]*\%(\*\|\d\+\)\=\%(\.\%(\*\|\d\+\)\)*[vTtbcdoqxXUeEfgGsp]/ contained containedin=goString,goRawString
endfunc!

func! synta#highlight_calls()
    syn match goCall /\(\w\+\.\)\?\w\+\ze(/
endfunc!

func! synta#highlight_calls_funcs()
    syn match goCall /\w\+\ze(/
endfunc!

func! synta#highlight()
    py synta.highlight_tags()
    if g:synta_go_highlight_calls == 1
        call synta#highlight_calls()
    endif
    if g:synta_go_highlight_calls_funcs == 1
        call synta#highlight_calls_funcs()
    endif
    call synta#highlight_builtins()
endfunc!

func! synta#rehighlight()
    py synta.generate_tags()
    call synta#highlight()
endfunc!

hi def link goReceiver Identifier
