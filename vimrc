color vylight
syn on
set nocompatible        " Be incompatible with vi, please
set backspace=2         " Backspace all the way to wherever it takes
set bioskey             " Use PC BIOS to read keyboard, for better ^C detection
set confirm             " Confirm dangerous commands
set cpoptions=cFs$      " Vi compatibility options
set helpheight=15       " 15 lines of help is enough, thank you
set incsearch           " Incremental searching
set infercase           " Infer case for ignorecase keyword completion
set keywordprg=man\ -a  " Display all man entries for `K' lookup
set laststatus=2        " Always show a status line
set notextmode          " Don't append bloody carriage returns
set ruler               " Enable ruler on status line
set scrolloff=3         " Keep 3 lines above and below cursor
set shortmess=ao        " Shorter status messages
set showbreak=+++\      " Precede continued screen lines
set showmatch           " Show matching delimiters
set showmode            " Show current input mode in status line
set sidescroll=8        " Horizontal scrolling 8 columns at a time
set smartcase           " Ignore ignorecase for uppercase letters in patterns
set splitbelow          " Split windows below current window
set nostartofline       " Do not home cursor to beginning of line
set ttyscroll=5         " Scroll at most 5 lines at a time
set whichwrap=<,>,[,]   " Left/right arrow keys wrap
set winheight=4         " At least 4 lines for current window
set winminheight=0      " Allow zero-height windows
" set cinoptions=:0,p0,t0,(1s             " C language indent options
set listchars=eol:$,tab:»·,trail:·      " List view format characters
set matchpairs=(:),{:},[:],<:>          " Matching pair characters
set wildmode=longest,list,list:full     " Bash-vim wildcard behavior
set textwidth=79
set history=500
"set lazyredraw
set ttyfast 
set et
set mousehide
set cindent
set viminfo='50,<1000,s100,:300,n~/.viminfo
set nu
" set viminfo='1000,:300,n~/.viminfo
" set cul                 " sets cursor highlighting
set nocul
set mouse=a
set clipboard+=unnamed

set hidden
set cscopequickfix=s-,c-,d-,i-,t-,e-
set wildignore=*.o,*.obj,ram-*,ssd-*,hdd-*,0x*,*.doc*,*stdout*,*stderr,*.dep,*_linux_d,*.vcproj,ext/include*

set nocp
filetype off
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on
syntax on
let c_space_errors = 1

" -- configs --
let OmniCpp_MayCompleteDot = 1 " autocomplete with .
let OmniCpp_MayCompleteArrow = 1 " autocomplete with ->
let OmniCpp_MayCompleteScope = 1 " autocomplete with ::
let OmniCpp_SelectFirstItem = 2 " select first item (but don't insert)
let OmniCpp_NamespaceSearch = 2 " search namespaces in this and included files
let OmniCpp_ShowPrototypeInAbbr = 1 " show function prototype (i.e. parameters) in popup window

" Tab and shiftwidth etc.
" set sts=4               " Use mixture tabs and spaces while editing.
set shiftwidth=4        " Indent by four columns at a time for >> and <<
set tabstop=4           " tab is x spaces
set expandtab           " tabs are spaces

" Remove the darn menu and the toolbar since rendering them 
" over a remote connection seems to take ages.
set guioptions-=T
set guioptions-=L
set guioptions-=r
set guioptions-=R
" set guioptions-=m

" vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END

set guifont=Bitstream\ Vera\ Sans\ Mono\ 11
set grepprg=grep\ -n\ -r\ $*\ *
set grepprg=internal

"source $VIMRUNTIME/ftplugin/man.vim

" Specific settings
set noequalalways

set path=$PWD/**
set tags=$PWD/tags
set ignorecase
let Tlist_Ctags_Cmd = '/usr/bin/ctags'

set path=$PWD/**

nmap :ff :cs find f 
nmap :sf :scs find f 

"""""
""""" ABBREVIATIONS
"""""

iabbrev Gau Gautam Gopinadhan
iabbrev hsw http://www
iabbrev teh the
iabbrev Teh The

"
" Windowing Maps
"
nmap <C-W><C-Right> <C-W><Right>
nmap <C-W><C-Left> <C-W><Left>
nmap <C-W><C-Up> <C-W><Up>
nmap <C-W><C-Down> <C-W><Down>

" <C-D>: toggle hlsearch
if version >= 500
  nnoremap <C-D> :set hlsearch!<CR>:set hlsearch?<CR>
endif

" New cscope connection
nmap _CS :cs kill -1<CR>:cs add cscope.out<CR>:set tags=$PWD/tags<CR>

" Update cscope data
nmap _CU :!cscope -b<CR>:cs kill -1<CR>:cs add cscope.out<CR>

" Regenerate new cscope data and map to it.
nmap _CR :!~/scripts/csgen.sh<CR>:cs kill -1<CR>:cs add cscope.out<CR>

" set find path
nmap _SF :set path=$PWD/**<CR>

" remove all Extra spaces
nmap _SS :%s/\s\+$//g<CR>

" Insert current date and time in ISO 8601 format
" into the file and the cut buffer
" nmap _D mdo<C-R>=strftime("[%Y-%m-%d %H:%M:%S]")<CR><Esc>0y$`d
nmap _D i<C-R>=strftime("[%Y-%m-%d %H:%M:%S]")<CR> <Esc>

" Re-source vim file
nmap _E :source <C-R>=MacrosDir<CR>.vim<Left><Left><Left><Left>vimrc

""""
"""" cscope stuff
""""

nmap <C-Space>s :scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>g :scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>c :scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>t :scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>e :scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-Space>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-Space>d :scs find d <C-R>=expand("<cword>")<CR><CR>

map <C> <Esc>

map gf gF
cs add cscope.out
