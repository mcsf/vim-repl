function! s:GetTextRange(start, end)
	return trim(join(getline(a:start, a:end), "\n")) . "\n"
endfunction

function! s:GetCurrentTextBlock()
	return s:GetTextRange(getpos("'{")[1], getpos("'}")[1])
endfunction

function! s:GetTerminalBuffer()
	if (! exists("b:repl_dst_term"))
		let b:repl_dst_term = s:ChooseTerminalBuffer()
	endif
	return b:repl_dst_term
endfunction

function! s:ChooseTerminalBuffer()
	let fmttd =  map(term_list(), {k, v -> "(" . (v) . ") " . bufname(v)})
	let choice = -1
	while choice != 0 && index(term_list(), choice) < 0
		echo "Choose a terminal:"
		let choice = inputlist(fmttd)
	endwhile
	return choice
endfunction

function! s:SendBlockToTerminal()
	call term_sendkeys(s:GetTerminalBuffer(), s:GetCurrentTextBlock())
endfunction

function! s:SendRangeToTerminal(start, end)
	call term_sendkeys(s:GetTerminalBuffer(), s:GetTextRange(a:start, a:end))
endfunction

command! REPLSendBlock call s:SendBlockToTerminal()
command! -range REPLSendSelection call s:SendRangeToTerminal(<line1>, <line2>)

nmap <buffer> <CR> :REPLSendBlock<CR>
vmap <buffer> <CR> :.REPLSendSelection<CR>
