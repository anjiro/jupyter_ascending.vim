let g:jupyter_ascending_python_executable = get(g:, 'jupyter_ascending_python_executable', 'python')
let g:jupyter_ascending_match_pattern     = get(g:, 'jupyter_ascending_match_pattern', '.sync.py')
let g:jupyter_ascending_auto_write        = get(g:, 'jupyter_ascending_auto_write', v:true)

augroup JupyterAscending
  au!
	execute 'autocmd BufRead,BufNewFile *'.g:jupyter_ascending_match_pattern 'call jupyter_ascending#init()'
augroup END


nnoremap <silent> <Plug>JupyterExecute    :call jupyter_ascending#execute()<CR>
nnoremap <silent> <Plug>JupyterExecuteAll :call jupyter_ascending#execute_all()<CR>
