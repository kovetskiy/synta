call ale#Set('go_goinstall_cmd', 'go install')

function! synta#ale#goinstall#Fix(buffer) abort
    let l:cmd = ale#Var(a:buffer, 'go_goinstall_cmd')

    return {
    \   'command': ale#Escape(l:cmd)
    \       . ' ' . ale#Escape(expand('%:h')),
    \   'read_temporary_file': 1,
    \}
endfunction
