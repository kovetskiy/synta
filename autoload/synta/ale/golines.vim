call ale#Set('go_golines_executable', 'golines')
call ale#Set('go_golines_max_length', '80')

function! synta#ale#golines#Fix(buffer) abort
    let l:executable = ale#Var(a:buffer, 'go_golines_executable')
    let l:length = ale#Var(a:buffer, 'go_golines_max_length')

    if !executable(l:executable)
        return 0
    endif

    return {
    \   'command': ale#Escape(l:executable)
    \       . ' -w'
    \       . ' -m ' . l:length
    \       . ' %t',
    \   'read_temporary_file': 1,
    \}
endfunction
