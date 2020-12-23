" basic features
syntax on
filetype on
set autoindent
set smartindent
set smartcase
set ignorecase

" down with hard tabs
set expandtab
" 4 space indent by default
set tabstop=4
set shiftwidth=4
" my terminal/editor backgrounds are always dark
set bg=dark

" this is not enough tab
set tabpagemax=400

" disable "smart" indent for python comments. this types a character 'X', then backspaces, then types #.
" this is really stupid.
inoremap # X#

" Ctrl+Space should probably be autocomplete instead of whaveter the hell it does normally
map  <Nul> <Nop>
imap <Nul> <C-N>
imap <C-Space> <C-N>
vmap <Nul> <Nop>
cmap <Nul> <Nop>
nmap <Nul> <Nop>
" nice try, Ex mode
map Q <Nop>
" i've never wanted to use ;
map ; :
" disable F1
map  <F1> <Nop>
imap <F1> <Nop>
vmap <F1> <Nop>
cmap <F1> <Nop>
nmap <F1> <Nop>
" reorder tabs with Ctrl+PageUp and Ctrl+PageDown
map <C-S-PageUp> :tabm -1<CR>
map <C-S-PageDown> :tabm +1<CR>

" Ctrl+A, Ctrl+X should not interpret numbers in C-style octal
set nrformats-=octal

" this is required in some strange terminal+ssh situations to make backspace and delete work properly
set bs=2

" manual ftdetect for some languages
autocmd BufNewFile,BufRead *.dorp set filetype=dorp
autocmd BufNewFile,BufRead *.zig set filetype=zig
autocmd BufNewFile,BufRead *.ll set filetype=llvm
autocmd BufNewFile,BufRead *.swarkland set filetype=swarkland
autocmd BufNewFile,BufRead *.as set filetype=actionscript

" some languages use hard tabs
autocmd FileType go setlocal noexpandtab
autocmd FileType make setlocal noexpandtab
autocmd FileType javascript setlocal noexpandtab

" indent 4, except for these languages, which indent 2
autocmd FileType html setlocal tabstop=2
autocmd FileType html setlocal shiftwidth=2
autocmd FileType css setlocal tabstop=2
autocmd FileType css setlocal shiftwidth=2
autocmd FileType javascript setlocal tabstop=2
autocmd FileType javascript setlocal shiftwidth=2
autocmd FileType proto setlocal tabstop=2
autocmd FileType proto setlocal shiftwidth=2

" swap files are more trouble than they're worth
set noswapfile

" xml files often have free text in english.
autocmd FileType xml setlocal spell
autocmd FileType xml syntax spell toplevel

" enable adding words to a dictionary with zg
let &spellfile=$HOME . "/.vim/spellbook." . &encoding . ".add"

if has("gui_running")
  " hide GVIM toolbar
  set guioptions -=T
  " this is the color scheme i like
  colorscheme desert
endif
