if exists('g:vim_squint_loaded')
	finish
endif
let g:vim_squint_loaded = 1

let s:active_groups = {}

function! SquintRegex(pattern, ...)
	let l:id_specified = a:0 > 0
	let l:hi_group_specified = a:0 > 1
	let l:identifier = l:id_specified ? a:1 : 'default'
	let l:group = l:hi_group_specified ? a:2 : "Comment"
	
	call Unsquint(l:identifier)
	let l:match_id = matchadd(l:group, a:pattern)
	let s:active_groups[l:identifier] = l:match_id
endfunction

function! ISquint(text, ...)
	" Hide all lines that DO match the regex
	call call("SquintRegex", [MatchLine(a:text)] + a:000)
endfunction

function! MatchLine(regex)
	return ".\\{-}" . a:regex . ".*"
endfunction

function! MatchLineInverted(regex)
	return "^\\(\\(" . a:regex . "\\)\\@!.\\)*$"
endfunction

function! Squint(text, ...)
	" Hide all lines that DO NOT match the regex
	call call("SquintRegex", [MatchLineInverted(a:text)] + a:000)
endfunction

function! Unsquint(...)
	let l:id_specified = a:0 > 0
	let l:identifier = l:id_specified ? a:1 : 'default'
	let l:id = get(s:active_groups, l:identifier, 0)
	if (l:id)
		let l:removed = matchdelete(l:id)
		unlet s:active_groups[l:identifier]
	endif
endfunction

function! UnsquintAll()
	for [group, id] in items(Squintlist())
		call Unsquint(group)
	endfor
endfunction

function! Squintlist()
	return copy(s:active_groups)
endfunction

function! s:SquintlistAutocomplete(ArgLead, CmdLine, CursorPos)
	return filter(keys(s:active_groups), {idx, val -> stridx(val, a:ArgLead) == 0})
endfunction

command! -nargs=+ Squint call Squint(<f-args>)
command! -nargs=+ ISquint call ISquint(<f-args>)
command! -nargs=+ SquintRegex call SquintRegex(<f-args>)
command! -complete=customlist,s:SquintlistAutocomplete -nargs=? Unsquint call Unsquint(<f-args>)
command! UnsquintAll call UnsquintAll()
command! Squintlist echo Squintlist(<f-args>)
