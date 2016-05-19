augroup _synta_go
    au!
    au BufWritePost *.go call synta#generate_and_highlight()
    au BufRead      *.go call synta#highlight()
    au BufNew       *.go call synta#generate_and_highlight()
augroup end
