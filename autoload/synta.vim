py import synta

func! synta#highlight_builtins()
    syn keyword goErr err
    syn keyword goConditional case default
    syn match goFormatSpecifier   /%[-#0 +]*\%(\*\|\d\+\)\=\%(\.\%(\*\|\d\+\)\)*[vTtbcdoqxXUeEfgGsp]/ contained containedin=goString,goRawString
endfunc!

func! synta#highlight_calls()
    syn match goCall /\(\w\+\.\)\?\w\+\ze(/
endfunc!

func! synta#highlight()
    py synta.highlight_tags()
    call synta#highlight_calls()
    call synta#highlight_builtins()
endfunc!

func! synta#rehighlight()
    py synta.generate_tags()
    call synta#highlight()
endfunc!

hi def link goReceiver Identifier
