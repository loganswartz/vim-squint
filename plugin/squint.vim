if exists('g:vim_squint_loaded')
	finish
endif
let g:vim_squint_loaded = 1

function! SquintRegex(pattern, ...)
	let l:id_specified = a:0 > 0
	let l:hi_group_specified = a:0 > 1
	let l:identifier = l:id_specified ? a:1 : 'default'
	let l:qualified = 'vimSquint' . '_' . l:identifier
	call Unsquint(l:identifier)
	
	execute "syntax match " . l:qualified . " /" . a:pattern . "/"
	execute "highlight link " . l:qualified . " " . (l:hi_group_specified ? a:2 : "Comment")
endfunction

function! Squint(text, ...)
	call call("SquintRegex", ["^.\\{-}" . a:text . ".\\{-}$"] + a:000)
endfunction

function! Unsquint(...)
	let l:id_specified = a:0 > 0
	let l:identifier = l:id_specified ? a:1 : 'default'
	let l:qualified = 'vimSquint' . '_' . l:identifier
	silent! execute "syntax clear " . l:qualified
	silent! execute "highlight clear " . l:qualified
endfunction

function! UnsquintAll()
	for id in Squintlist()
		call Unsquint(id)
	endfor
endfunction

function! Squintlist()
	let l:all_hi_groups = getcompletion('','highlight')
	let l:filtered = filter(l:all_hi_groups, {idx, val -> stridx(val, 'vimSquint_') == 0})
	let l:stripped = map(l:filtered, {idx, val -> val[10:]})
	return l:stripped
endfunction

function! s:SquintlistAutocomplete(ArgLead, CmdLine, CursorPos)
	return filter(Squintlist(), {idx, val -> stridx(val, a:ArgLead) == 0})
endfunction

command! -nargs=+ Squint call Squint(<f-args>)
command! -nargs=+ SquintRegex call SquintRegex(<f-args>)
command! -complete=customlist,SquintlistAutocomplete -nargs=? Unsquint call Unsquint(<f-args>)
command! UnsquintAll call UnsquintAll()
command! Squintlist echo Squintlist(<f-args>)
