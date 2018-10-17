" basic settings
syntax on
filetype on
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent
set smartcase
set ignorecase
set bg=dark

" disable "smart" indent for python comments. this types a character 'X', then backspaces, then types #.
inoremap # X#

" this is not enough tab
set tabpagemax=400

" Ctrl+Space should probably be autocomplete instead of whaveter the hell it does normally
map  <Nul> <Nop>
imap <Nul> <C-N>
imap <C-Space> <C-N>
vmap <Nul> <Nop>
cmap <Nul> <Nop>
nmap <Nul> <Nop>
" nice try, Ex mode
map Q <Nop>
" who uses semicolon anyway?
map ; :
" F1 is the most helpfulest of all keys
map  <F1> <Nop>
imap <F1> <Nop>
vmap <F1> <Nop>
cmap <F1> <Nop>
nmap <F1> <Nop>
" reorder tabs
map <C-S-PageUp> :tabm -1<CR>
map <C-S-PageDown> :tabm +1<CR>
" go home, octal. you're drunk
set nrformats-=octal

set bs=2


autocmd BufNewFile,BufRead *.dorp set filetype=dorp
autocmd BufNewFile,BufRead *.zig set filetype=zig
autocmd BufNewFile,BufRead *.ll set filetype=llvm
autocmd BufNewFile,BufRead *.swarkland set filetype=swarkland
autocmd BufNewFile,BufRead *.as set filetype=actionscript

" some languages use hard tabs
autocmd FileType go setlocal noexpandtab
autocmd FileType make setlocal noexpandtab

" indent 2, except for these languages, which indent 4
autocmd FileType c setlocal tabstop=4
autocmd FileType c setlocal shiftwidth=4
autocmd FileType cpp setlocal tabstop=4
autocmd FileType cpp setlocal shiftwidth=4
autocmd FileType zig setlocal tabstop=4
autocmd FileType zig setlocal shiftwidth=4
autocmd FileType python setlocal tabstop=4
autocmd FileType python setlocal shiftwidth=4

set noswapfile

autocmd FileType xml setlocal spell
autocmd FileType xml syntax spell toplevel
let &spellfile=$HOME . "/.vim/spellbook." . &encoding . ".add"
let g:syntastic_java_checkers = []
let g:syntastic_docbk_checkers = []
let g:syntastic_xml_checkers = []
let g:syntastic_cpp_checkers = []
let g:syntastic_c_checkers = []

" hide GVIM toolbar
if has("gui_running")
  set guioptions -=T
  colorscheme desert
endif

let g:syntastic_mode_map = { 'passive_filetypes': ['python'] }
