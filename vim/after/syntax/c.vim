imap {<CR> {<CR><CR>}<Up><Esc><Insert><Tab>
imap {} {}<Left>
ino  "" ""<Left>
imap [] []<Left>
imap (<Space> (<Space><Space>)<Left><Left>
ino () ()
ino /*<CR> /*<CR><Space>*<Space><CR>*/<Up>
ino /*<Space> /*<Space><Space>*/<Left><Left><Left>
ino /** /**<CR><Space>*<Space><CR>*/<Up><Left> 

func! FilterChar(pat)
  let c = getchar()
  return (c == a:pat) ? '' : nr2char(c)
endfunc

inorea fpe fprintf( stderr, "\\n" );<Esc>5hi<C-R>=FilterChar(32)<CR>
inorea fpo fprintf( stdout, "\\n" );<Esc>5hi<C-R>=FilterChar(32)<CR>
inorea ifpe #ifdef _DEBUG<CR><CR>#endif /* _DEBUG */<Up>fprintf( stderr, "\\n%s:%d::", __FILE__, __LINE__ );<Esc>23hi<C-R>=FilterChar(32)<CR>
inorea ifpo #ifdef _DEBUG<CR><CR>#endif /* _DEBUG */<Up>fprintf( stdout, "\\n%s:%d::", __FILE__, __LINE__ );<Esc>23hi<C-R>=FilterChar(32)<CR>
