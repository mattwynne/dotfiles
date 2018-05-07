call pathogen#infect()

" Use Vim setting instead of Vi
set nocompatible

" Backspace over everything
set backspace=indent,eol,start

let mapleader = ","   " Leader

set visualbell        " No bell
set number
set nobackup          " Don't keep backup files
set noswapfile        " Don't use swp files
set nowritebackup     " Don't make backups when overwriting files
set history=50        " Lines of history
set hidden            " Allow buffer switching with unsaved changes
set showcmd           " Display incomplete commands
set laststatus=2      " Always show status bar
set formatoptions-=o  " don’t continue comments when pressing o/O
set numberwidth=5
set incsearch         " Incremental searching
set ignorecase        " Ignore case in searches
set smartcase         "   when downcase

" statusline
" cf the default statusline: %<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" format markers:
"   %< truncation point
"   %n buffer number
"   %f relative path to file
"   %m modified flag [+] (modified), [-] (unmodifiable) or nothing
"   %r readonly flag [RO]
"   %y filetype [ruby]
"   %= split point for left and right justification
"   %-35. width specification
"   %l current line number
"   %L number of lines in buffer
"   %c current column number
"   %V current virtual column number (-n), if different from %c
"   %P percentage through buffer
"   %) end of width specification
set statusline=%<\ %n:%f\ %m%r%y%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%)

" Soft tabs, 2 character width
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

" Show tabs, trailing whitespace and end of lines
set list listchars=tab:»·,trail:·,eol:¬

" Completion
set completeopt=longest,menu
set wildmode=list:longest,list:full
set complete=.,t

" Scroll offsets
set scrolloff=3
set sidescroll=1
set sidescrolloff=3

" Default split positioning
set splitbelow
set splitright

" Syntax and search highlighting
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

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

" Configure Ctags
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

" NERDTree
map <Leader>nt :NERDTreeToggle<CR>

function! Preserve(command)
  " preparation: save last search and cursor position
  let _s = @/
  let l = line(".")
  let c = col(".")
  " execute the command
  execute a:command
  " cleanup: restore search history and cursor position
  let @/ = _s
  call cursor(l, c)
endfunction

nmap _$ :call Preserve("%s/\\s\\+$//e")<CR>
nmap _= :call Preserve("normal gg=G")<CR>

" easier window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

function! VisualSearch(direction) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  elseif a:direction == 'gv'
    call CmdLine("vimgrep " . '/' . l:pattern . '/' . ' **/*.')
  elseif a:direction == 'f'
    execute "normal /" . l:pattern . "^M"
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>
vnoremap <silent> gv :call VisualSearch('gv')<CR>


set background=dark
colorscheme solarized

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
map <leader><space> :call ReRunTestCommand()<cr>

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\)$') != -1
    if in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    if match(expand("%"), '_test\.rb$') != -1
      call RunTestFile() " line number not right for minitest - TODO: Find nearest test name?
    else
      call RunTestFile(":" . spec_line_number)
    end
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    if match(a:filename, '\.feature') != -1
        if filereadable("script/features")
            let run_test = "script/features " . a:filename
        else
            let run_test = "bundle exec cucumber --color -f pretty " . a:filename
        end
    elseif match(a:filename, '_spec\.rb') != -1
        if filereadable("script/test")
            let run_test = "script/test " . a:filename
        else
            let run_test = "bundle exec rspec --color " . a:filename
        end
    else
        if filereadable("script/test")
            let run_test = "script/test " . a:filename
        else
            let run_test = "bundle exec ruby " . a:filename
        end
    end
    call RunTestCommand(run_test)
endfunction

function! RunTestCommand(cmd)
    if match(a:cmd, '.') != -1
      let t:sst_test_command = a:cmd
    end
    exec ":w"
    " check for a test-commands pipe, and execute tests async
    if filewritable(".test-commands")
      exec ":silent !echo " . t:sst_test_command . " > .test-commands"

      redraw!
    else
      exec ":!clear;" . t:sst_test_command
    end
endfunction

function! ReRunTestCommand()
  call RunTestCommand("")
endfunction

" https://github.com/scrooloose/nerdtree/issues/386
aunmenu Help.
let no_buffers_menu=1

" swap buffer
nnoremap <leader>, :b#<CR>

let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'
