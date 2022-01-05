if exists('g:jupyter_ascending_loaded')
	finish
endif

function! jupyter_ascending#init() abort " {{{1
	augroup JupyterAscendingBuffer
		au! * <buffer>
		if g:jupyter_ascending_auto_write
			autocmd BufWritePost <buffer> call jupyter_ascending#sync()
		endif
	augroup END

	if get(g:, 'jupyter_ascending_default_mappings', v:true)
		nmap <silent> <buffer> <space><space>x <Plug>JupyterExecute
		nmap <silent> <buffer> <space><space>X <Plug>JupyterExecuteAll
	endif

	echom "Initalize Jupyter Ascending python, please wait..."
	redraw!
	call jupyter_ascending#pyinit()
	echom "...done"
endfunction

" }}}1
function! jupyter_ascending#pyinit() abort " {{{1
	if exists('g:jupyter_ascending_py_initialized')
		return
	endif
py3 << EOF
import vim, tempfile, os
import jupyter_ascending._environment as ja_env
from loguru import logger as ja_logger
ja_logfile = os.path.join(tempfile.gettempdir(), "jupyter_ascending", "log.log")
ja_config = {"handlers": [
		{
			"sink":     ja_logfile,
			"serialize": False,
			"level":     ja_env.LOG_LEVEL,
		},
		{
			"sink":   sys.stdout,
			"format": "{time} - {message}",
			"level":  "WARNING",
		},
	],
}
ja_logger.configure(**ja_config)
vim.vars['ja_logfile'] = ja_logfile

ja_env.EXECUTE_HOST_URL = vim.vars.get('jupyter_ascending_execute_url', ja_env.EXECUTE_HOST_URL)

import jupyter_ascending.requests.sync        as ja_sync
import jupyter_ascending.requests.execute     as ja_execute
import jupyter_ascending.requests.execute_all as ja_execute_all

print('Initialized jupyter_ascending')
EOF

	let g:jupyter_ascending_py_initialized = 1
endfunction

" }}}1
function! jupyter_ascending#sync() abort " {{{1
	py3 ja_sync.send(vim.current.buffer.name)
endfunction

" }}}1
function! jupyter_ascending#execute() abort " {{{1
	py3 ja_execute.send(vim.current.buffer.name, vim.current.window.cursor[0])
endfunction

" }}}1
function! jupyter_ascending#execute_all() abort " {{{1
	py3 ja_execute_all.send(vim.current.buffer.name)
endfunction

" }}}1
function! s:do_ja_cmd(cmd) abort " {{{1
	if a:cmd ==# 'sync'
		let 
endfunction

" }}}1
let g:jupyter_ascending_loaded = 1
