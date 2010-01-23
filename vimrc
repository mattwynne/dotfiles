set nocompatible

set backspace=indent,eol,start

set visualbell
set nobackup
set nowritebackup
set history=50
set hidden    " allow buffer switching with unsaved changes
set ruler     " always show cursor position
set showcmd   " display incomplete commands
set incsearch
let mapleader = ","

set tabstop=2
set shiftwidth=2
set expandtab

set formatoptions-=o " don’t continue comments when pressing o/O

" show status bar and trailing whitespace
set laststatus=2
set list listchars=tab:»·,trail:·

" line numbers
"set number
set numberwidth=5

set ignorecase
set smartcase

" tab completion
set completeopt=longest,menu
set wildmode=list:longest,list:full
set complete=.,t

" scroll behaviour
set scrolloff=3
set sidescroll=1
set sidescrolloff=3

" default split positioning
set splitbelow
set splitright

" Don't use Ex mode, use Q for formatting
map Q gq


" syntax and search highlighting when terminal has colours
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
  set hlsearch
endif

" use ack instead of grep
if executable("ack")
  set grepprg=ack\ -H\ --nogroup\ --nocolor
endif

" quick git blame
vmap <Leader>g :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

if has("autocmd")
  filetype plugin indent on

  augroup vimrcEx
  au!

  autocmd FileType text setlocal textwidth=80

  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else
  set autoindent
endif

"define :HighlightLongLines command to highlight the offending parts of
"lines that are longer than the specified length (defaulting to 80)
command! -nargs=? HighlightLongLines call s:HighlightLongLines('<args>')
function! s:HighlightLongLines(width)
    let targetWidth = a:width != '' ? a:width : 79
    if targetWidth > 0
        exec 'match Todo /\%>' . (targetWidth) . 'v/'
    else
        echomsg "Usage: HighlightLongLines [natural number]"
    endif
endfunction
:map <Leader>h :HighlightLongLines<CR>

" ,t to find a file and open it in this buffer
:map <Leader>t :FuzzyFinderTextMate<CR>
" ,b to search the buffers currently open
:map <Leader>b :FuzzyFinderBuffer<CR>
let g:fuzzy_ceiling=50000
let g:fuzzy_ignore = "*.log" 
let g:fuzzy_matching_limit = 70

" Edit the README_FOR_APP (makes :R commands work)
map <Leader>R :e doc/README_FOR_APP<CR>
 
" Leader shortcuts for Rails commands
map <Leader>m :Rmodel<CR>
map <Leader>c :Rcontroller<CR>
map <Leader>v :Rview<CR>
map <Leader>u :Runittest<CR>
map <Leader>f :Rfunctionaltest<CR>
map <Leader>tm :RTmodel<CR>
map <Leader>tc :RTcontroller<CR>
map <Leader>tv :RTview<CR>
map <Leader>tu :RTunittest<CR>
map <Leader>tf :RTfunctionaltest<CR>
map <Leader>sm :RSmodel<CR>
map <Leader>sc :RScontroller<CR>
map <Leader>sv :RSview<CR>
map <Leader>su :RSunittest<CR>
map <Leader>sf :RSfunctionaltest<CR>

" Tags
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

map <Leader>nt :NERDTreeToggle<CR>
