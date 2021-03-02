function! s:GetTextRange(start, end)
	return trim(join(getline(a:start, a:end), "\n")) . "\n"
endfunction

function! s:GetCurrentTextBlock()
	return s:GetTextRange(getpos("'{")[1], getpos("'}")[1])
endfunction

function! s:GetTerminalBuffer()
	if (! exists("b:dst_term"))
		let b:dst_term = s:ChooseTerminalBuffer()
	endif
	return b:dst_term
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

command! SendBlock call s:SendBlockToTerminal()
command! -range SendSelection call s:SendRangeToTerminal(<line1>, <line2>)
command! SendBlockSetEnterKey map <buffer> <CR> :SendBlock<CR>|
            \ vmap <buffer> <CR> :.SendSelection<CR>
