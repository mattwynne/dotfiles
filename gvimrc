set guifont=Inconsolata:h24.00
set guioptions-=T " no toolbar
set guioptions+=c " use console dialogs

colorscheme railscasts

" no scrollbars
set guioptions-=R
set guioptions-=r
set guioptions-=L
set guioptions-=l

set encoding=utf-8

if has("gui_macvim")
  set fuoptions=maxvert,maxhorz
endif

