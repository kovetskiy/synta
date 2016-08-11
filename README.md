## Motivation

todo.

## Installation

For first, you need install my patched version of gotags:

```
go get github.com/kovetskiy/gotags
```

And install following vim plugins:

```
Plug 'kovetskiy/vim-hacks'
Plug 'kovetskiy/synta'
```

And, of course, you need to install `go-fast`:

[https://github.com/kovetskiy/go-fast](https://github.com/kovetskiy/go-fast)

## Usage

```
augroup operations_go
    au!
    au FileType go nmap <buffer> <Leader>, :call synta#go#build()<CR>
    au FileType go imap <buffer> <Leader>, <ESC>:call synta#go#build()<CR>
augroup end
```
