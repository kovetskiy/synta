call ale#Set('go_goinstalldeps_executable', 'go-install-deps')

function! synta#ale#goinstalldeps#Fix(buffer) abort
    let l:executable = ale#Var(a:buffer, 'go_goinstalldeps_executable')

    if !executable(l:executable)
        return 0
    endif

    return {
    \   'command': ale#Escape(l:executable)
    \       . ' ' . ale#Escape(expand('%:h')),
    \   'read_temporary_file': 1,
    \}
endfunction
