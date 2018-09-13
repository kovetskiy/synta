call ale#Set('go_goinstall_cmd', 'go install')

function! synta#ale#goinstall#Fix(buffer) abort
    let l:cmd = ale#Var(a:buffer, 'go_goinstall_cmd')

    let l:result = {
    \   'command': l:cmd
    \       . ' ' . ale#Escape(expand('%:p:h')),
    \   'read_temporary_file': 1,
    \}

    return l:result
endfunction
