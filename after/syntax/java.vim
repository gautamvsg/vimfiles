" Commonly used bracket abbreviations for java
" imap { {<CR><CR>}<Up><Tab>
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

inorea Sys System.out.println("");<Left><Left><Left><C-R>=FilterChar(32)<CR>
