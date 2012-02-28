" manpageview.vim : extra commands for manual-handling
" Author: Charles E. Campbell, Jr.
" Date: Oct 31, 2003
" Version: 5
"
" Usage:
"  :Man topic
"  :Man topic booknumber  -or-  :Man booknumber topic
"  :Man topic(booknumber)
"  Put cursor on topic, press "K" while in normal mode
"  :Man      -- will restore position prior to use of :Man
"               (only for g:manpageview_winopen == "only")
"
"  If your man requires options, please specify them with
"  g:manpageview_options in your <.vimrc>:
"
" Options:
"
"   g:manpageview_options : extra options that will be
"                           passed on to the invocation
"                           of man
"     examples:
"               let g:manpageview_options= "-P 'cat -'"
"               let g:manpageview_options= "-c"
"               let g:manpageview_options= "-Tascii"
"
"   g:manpageview_winopen : may take on one of three values:
"      "only"    man page will become sole window.
"                Side effect: All windows' contents will be saved first!  (windo w)
"                Use :q to terminate the manpage and restore the window setup.
"                Note that mksession is used for this option, hence the
"                +mksession configure-option is required.
"      "hsplit"  man page will appear in a horizontally          split window (default)
"      "vsplit"  man page will appear in a vertically            split window
"      "hsplit=" man page will appear in a horizontally & evenly split window
"      "vsplit=" man page will appear in a vertically   & evenly split window
"      "reuse"   man page will re-use current window.  Use <ctrl-o> to return.
"
"   g:manpageview_server : for WinNT; uses rsh to read manpage remotely
"   g:manpageview_user   : use given server (host) and username
"     examples:
"               let g:manpageview_server= "somehostname"
"               let g:manpageview_user  = "username"
"
" History:
"  5 : includes g:manpageview_winmethod option (only, hsplit, vsplit)
"  4 : jhf.remmelzwaal suggested including, for the benefit of NT
"      users, a command to use rsh to read the manpage remotely.
"      Set g:manpageview_server to hostname  (in your <.vimrc>)
"           g:manpageview_user   to username
"  3 : * ignores (...) if it contains commas or double quotes.
"        elides any commas, colons, and semi-colons at end
"      * g:manpageview_options supported
"  2 : saves current session prior to invoking man pages
"      :Man    will restore session.  Requires +mksession
"      for this new command to work.
"  1 : the epoch

" prevent double-loading
if &cp || exists("s:loaded_manpageview")
 finish
endif
let s:loaded_manpageview= 1

" set up default manual-window opening option
if !exists("g:manpageview_winopen")
 let g:manpageview_winopen= "hsplit"
elseif g:manpageview_winopen == "only" && !has("mksession")
 echomsg "***g:manpageview_winopen<".g:manpageview_winopen."> not supported w/o +mksession"
 let g:manpageview_winopen= "hsplit"
endif

" Public Interface:
if !hasmapto('<Plug>ManPageView')
  nmap <unique> K <Plug>ManPageView
endif
nmap <silent> <script> <Plug>ManPageView  :silent call <SID>ManPageView(expand("<cWORD>"))<CR>
com! -nargs=*	Man silent! call <SID>ManPageView(<f-args>)

if !exists("g:manpageview_options")
 let g:manpageview_options= ""
endif

" ---------------------------------------------------------------------

" ManPageView: view a manual-page, accepts three formats:
"    :call ManPageView("topic")
"    :call ManPageView(booknumber,"topic")
"    :call ManPageView("topic(booknumber)")
fu! <SID>ManPageView(...)
  set lz

  if a:0 == 0
   if exists("g:ManCurPosn") && has("mksession")
"    call Decho("ManPageView: a:0=".a:0."  g:ManCurPosn exists")
	call s:ManRestorePosn()
   else
    echomsg "***usage*** :Man topic  -or-  :Man topic nmbr"
"    call Decho("ManPageView: a:0=".a:0."  g:ManCurPosn doesn't exist")
   endif
   return

  elseif a:0 == 1
"   call Decho("ManPageView: a:0=".a:0." a:1<".a:1.">")
   if a:1 =~ "("
	" abc(3)
	let a1 = substitute(a:1,'[-+*/;,.:]\+$','','e')
	if a1 =~ '[,"]'
     let manpagetopic= substitute(a1,'[(,"].*$','','e')
     let manpagebook = ""
	else
     let manpagetopic= substitute(a1,'^\(.*\)(\d\+[A-Z]\=),\=','\1','e')
     let manpagebook = substitute(a1,'^.*(\(\d\+\)[A-Z]\=),\=','\1','e')
	endif
   else
    " abc
    let manpagetopic= a:1
    let manpagebook = ""
   endif

  else
   " 3 abc  -or-  abc 3
   if     a:1 =~ '^\d\+'
    let manpagebook = a:1
    let manpagetopic= a:2
   elseif a:2 =~ '^\d\+$'
    let manpagebook = a:2
    let manpagetopic= a:1
   else
	" default: topic book
    let manpagebook = a:2
    let manpagetopic= a:1
   endif
  endif

  " This code decides on what window the manpage will be displayed
  if     g:manpageview_winopen == "only"
   silent! windo w
   if !exists("g:ManCurPosn") && has("mksession")
    call s:ManSavePosn()
   endif
   " Record current file/position/screen-position
   only!
   enew!
  elseif g:manpageview_winopen == "hsplit"
   wincmd s
   enew!
   wincmd _
   3wincmd -
  elseif g:manpageview_winopen == "hsplit="
   wincmd s
   enew!
  elseif g:manpageview_winopen == "vsplit"
   wincmd v
   enew!
   wincmd |
   3wincmd <
  elseif g:manpageview_winopen == "vsplit="
   wincmd v
   enew!
  elseif g:manpageview_winopen == "reuse"
   enew!
  else
   echoerr "sorry, g:manpageview_winopen<".g:manpageview_winopen."> not supported"
   return
  endif

  " invoke the man command to get the manpage
  set mod
"  call Decho("manpagebook<".manpagebook."> topic<".manpagetopic.">")
  if has("win32") && exists("g:manpageview_server") && exists("g:manpageview_user")
   exe "r!rsh g:manpageview_server -l g:manpageview_user man
  else
   exe "r!man ".g:manpageview_options." ".manpagebook." ".manpagetopic
   %!col -b
  endif
  setlocal ft=man nomod nolist
  set nolz
endfunction

" ---------------------------------------------------------------------

" ManRestorePosn:  uses g:ManCurPosn to restore file/position/screen-position
fu! <SID>ManRestorePosn()
  if exists("g:ManCurPosn")
"   call Decho("ManRestorePosn: g:ManCurPosn<".g:ManCurPosn.">")
   exe 'silent! source '.g:ManCurPosn
   unlet g:ManCurPosn
   cunmap q
  endif
endfunction

" ---------------------------------------------------------------------

" ManSavePosn: saves current file, line, column, and screen position
fu! <SID>ManSavePosn()
"  call Decho("ManSavePosn")
  let g:ManCurPosn= tempname()
  let keep_ssop   = &ssop
  let &ssop       = 'winpos,buffers,slash,globals,resize,blank,folds,help,options,winsize'
  exe 'silent! mksession! '.g:ManCurPosn
  let &ssop       = keep_ssop
  cnoremap <silent> q call <SID>ManRestorePosn()<CR>
endfunction

" ---------------------------------------------------------------------

