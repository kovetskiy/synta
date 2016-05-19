augroup _synta_go
    au!
    au BufWritePost *.go call synta#rehighlight()
    au BufEnter     *.go call synta#highlight()
    au BufNew       *.go call synta#rehighlight()
augroup end
