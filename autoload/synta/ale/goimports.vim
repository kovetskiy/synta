call ale#Set('go_goimports_executable', 'goimports')

function! synta#ale#goimports#Fix(buffer) abort
    let l:executable = ale#Var(a:buffer, 'go_goimports_executable')

    if !executable(l:executable)
        return 0
    endif

    return {
    \   'command': ale#Escape(l:executable)
    \       . ' -l -w'
    \       . ' -srcdir ' . ale#Escape(expand('%:h'))
    \       . ' %t',
    \   'read_temporary_file': 1,
    \}
endfunction
