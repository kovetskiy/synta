if exists("b:synta_current_syntax")
  finish
endif

if get(g:, 'synta_go_highlight_calls', 1) == 1
    call synta#highlight_calls()
endif

if get(g:, 'synta_go_highlight_calls_funcs', 0) == 1
    call synta#highlight_calls_funcs()
endif

let b:synta_current_syntax = "go"
