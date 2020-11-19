" Only load if not already loaded.
if exists('g:loaded_nvim_cust_utils') || &cp
  finish
endif
let g:loaded_nvim_cust_utils = 1

" Plugin start

lua lua_utils = require('lua_utils')

let g:pytesting_ready = 0

augroup PythonMake
    autocmd!
    autocmd BufEnter *.py call s:SetupPythonEnv()
augroup END

function s:SetupPythonEnv() abort
    call s:MakeToRightPython()
    if s:CheckForPipfile() && $VIRTUAL_ENV == ""
        call s:VirtEnvGet()
    endif
endfunction

function! g:SetVirtEnv(job_id, data, event) abort
    " Inserts pipenv virtualenv bin path as first item in $PATH
    " if the bin path is already not on $PATH
    if len(a:data) == 0
        echoerr "a:data was empty: " . a:data
        return
    elseif len(a:data) <= 2
        let s:text = a:data[0]
    elseif len(a:data) > 2
        echoerr "a:data was of len 2: " . a:data
        return
    endif
    if a:event == 'stdout' && s:text =~ "python3"
        let s:pythonpath = substitute(s:text, "/python3", "", "")
        let $PYTHONPATH = s:pythonpath
        " let $PATH .= ":" . s:pythonpath
        if !(expand("$PATH") =~ s:pythonpath)
            " If PATH does not already contain current pipenv python path ->
            " Insert into the front of PATH
            let $PATH = s:pythonpath . ":" . $PATH
            CocRestart
        endif
    else
        return
    endif

endfunction

function! s:VirtEnvGet() abort
    " Changes vim directory to Rooter (root folder with .git)
    " and then uses pipenv to get the python executable path async.
    if exists(":Rooter") > 0
        Rooter
    else
        execute "cd %:p:h"
    endif
    let s:jobid = jobstart("pipenv run which python3", {'on_stdout': "g:SetVirtEnv"})
endfunction

function s:CheckForPipfile() abort
    " Checks for Pipfile in current directory and one above
    " Returns 1 if found and 0 otherwise
    let s:parent = expand("%:p:h")
    let s:parentparent = expand("%:p:h:h")
    if filereadable(s:parent . "/Pipfile")
                \ || filereadable(s:parentparent . "/Pipfile")
        return 1
    else
        return 0
    endif
    
endfunction

function s:MakeToRightPython() abort
    if s:CheckForPipfile()
        set makeprg=pipenv\ run\ pytest
        let g:pytesting_ready = 1
    elseif exists($VIRTUAL_ENV)
        " I rarely do development outside of pipenv -> unlikely virtual envs
        " use pytest
        set makeprg=python3\ %
        let g:pytesting_ready = 1
    endif
endfunction


" function! s:TogglePytesting()
"     if g:pytesting_toggle
"         call s:DisablePytesting()
"     else
"         call s:EnablePytesting()
"     endif
" endfunction

" function! s:DisablePytesting()
"     augroup Pytesting
"         autocmd!
"     augroup END
"     let g:pytesting_toggle = 0
"     echo "Pytesting disabled."
" endfunction

" function! s:EnablePytesting()
"     augroup Pytesting
"         autocmd!
"         autocmd BufWritePost *.py call s:LocationalPytest()
"     augroup END
"     let g:pytesting_toggle = 1
"     echo "Pytesting enabled."
" endfunction

" function! s:LocationalPytest() abort
"     if !g:pytesting_ready && !exists($VIRTUAL_ENV)
"         echoerr "Pytest failed: Not in virtual env or pipenv not located."
"         return
"     endif
"     let s:syn_name = synIDattr(synID(line("."), col("."), 1), "name")
"     if s:syn_name == "pythonFunction"
"         " Cursor is on a python function -> test with the function name
"         " as pattern for pytest -k
"         let s:pytest_pattern = expand("<cword>")
"     else
"         " Else use current filename without suffix as pattern
"         let s:pytest_pattern = 
"                     \ substitute(expand("%:t"), ".". expand("%:e"), "", "")
"     endif
"     execute("Make -k " . s:pytest_pattern)
" endfunction

function! s:LocationalPytest() abort
    " VIRTUAL_ENV is probably checked few too many times.
    if !g:pytesting_ready
        echoerr "LocationalPytest failed: Not in virtual env or Pipfile not located."
        return
    endif
    " Returns class or function name. If in method -> returns class name.
    let s:pytest_pattern = v:lua.lua_utils.get_curr_parent()
    if len(s:pytest_pattern) == 0
        " Use current filename without suffix as pattern when empty
        let s:pytest_pattern =
                    \ substitute(expand("%:t"), ".". expand("%:e"), "", "")
    endif
    " echo s:pytest_pattern
    execute("Make -k " . s:pytest_pattern)
endfunction

" command! Pytesting call s:TogglePytesting()
command! Pytest call s:LocationalPytest()
