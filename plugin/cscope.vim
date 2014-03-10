" vim: tabstop=2 shiftwidth=2 softtabstop=2 expandtab foldmethod=marker
"    Copyright: Copyright (C) 2012 Brook Hong
"    Copyright: Copyright (C) 2013 Chang Yu-heng (張昱珩)
"    License: The MIT License
"


" Load Cscope database, if it's absent find the parent directory recursively.
au BufEnter /* call LoadDb()

set cscopetag
set cscopequickfix=s-,g-,d-,c-,t-,e-,f-,i-
" s: Find this C symbol
map <leader>fs :call CscopeFind('s', expand('<cword>'))<CR>
" g: Find this definition
map <leader>fg :call CscopeFind('g', expand('<cword>'))<CR>
" d: Find functions called by this function
map <leader>fd :call CscopeFind('d', expand('<cword>'))<CR>
" c: Find functions calling this function
map <leader>fc :call CscopeFind('c', expand('<cword>'))<CR>
" t: Find this text string
map <leader>ft :call CscopeFind('t', expand('<cword>'))<CR>
" e: Find this egrep pattern
map <leader>fe :call CscopeFind('e', expand('<cword>'))<CR>
" f: Find this file
map <leader>ff :call CscopeFind('f', expand('<cword>'))<CR>
" i: Find files #including this file
map <leader>fi :call CscopeFind('i', expand('<cword>'))<CR>
map <leader>l :call ToggleLocationList()<CR>

function! ToggleLocationList()
  let l:own = winnr()
  lw
  let l:cwn = winnr()
  if(l:cwn == l:own)
    if &buftype == 'quickfix'
      lclose
    elseif len(getloclist(winnr())) > 0
      lclose
    else
      echohl WarningMsg | echo "No location list." | echohl None
    endif
  endif
endfunction

function! CscopeFind(action, word)
  exe ':lcs f '.a:action.' '.a:word
  lw
endfunction

if !exists('g:cscope_cmd')
  let g:cscope_cmd = 'cscope'
endif

function! LoadDb()
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
  endif
endfunction
