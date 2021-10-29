" line numbers
set nu rnu

" tabs/spaces size
set ts=4 sw=4
set autoindent
set spell
set backspace=indent,eol,start
set smartindent

" USE FOR SPACE OVER TABS
" set tabstop=4 shiftwidth=4 expandtab softtabstop=4

syntax on
set fileencoding=utf-8
set encoding=utf-8
set hlsearch

set t_Co=256
set background=dark
colo gruvbox
hi Normal guibg=NONE ctermbg=NONE

" SPECIFIC FILE CONFIG
autocmd BufEnter *.py set sta et fo=croql
autocmd BufEnter *.yml set sw=2 ts=2 sta et fo=croql
autocmd BufEnter *.html set sw=2 ts=2 
autocmd BufEnter *.blade.php set sw=2 ts=2

" STATUS LINE
let gitBranch=system("git branch --show-current 2> /dev/null")
set laststatus=2

" Left align
set statusline=
execute "set statusline +=%1*\\ " . gitBranch
set statusline +=\ %3*\ %y\  			" file type
set statusline +=%0*\ %f				" file name
									
" Right align
set statusline +=%0*\ %=%l				" current line
set statusline +=%0*\ /%L\ 				" total lines
set statusline +=%3*\ [%03p%%]\ 		" total lines
set statusline +=%2*\ [%{&ff}\]\ 		" file type

" colors
hi User0 ctermbg=DarkGrey
hi User1 ctermbg=DarkGreen
hi User2 ctermbg=DarkYellow
hi User3 ctermbg=DarkCyan

" COLORS AND STUFF
" best color delek, koehler, desert, zellner, 
" slate -> main blue + small green accent
" zellner -> red + purple + dark
" desert -> closest to jetbrain darkula
" :highlight SpellBad ctermfg=009 ctermbg=011 guifg=#ff0000 guibg=#ffff00
