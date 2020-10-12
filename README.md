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

## Usage

```
augroup operations_go
    au!
    au FileType go nmap <buffer> <Leader>, :call synta#go#build()<CR>
    au FileType go imap <buffer> <Leader>, <ESC>:call synta#go#build()<CR>
augroup end
```

Specify fixer for ale
```
    let g:ale_fixers = {
    \   'go': [function("synta#ale#goimports#Fix"), function("synta#ale#goinstalldeps#Fix")],
    \}
    \}
    let g:ale_linters = {
    \   'go': ['gobuild'],
    \}
    let g:ale_fix_on_save = 1
```
