command! REPLSendBlock call repl#SendBlockToTerminal()
command! -range REPLSendSelection call repl#SendRangeToTerminal(<line1>, <line2>)
command! REPLEnableBuffer nnoremap <buffer> <CR> :REPLSendBlock<CR> | vnoremap <buffer> <CR> :.REPLSendSelection<CR>

REPLEnableBuffer
