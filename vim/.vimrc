set nocompatible              " be iMproved, required

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'ctrlp.vim'
Plug 'scrooloose/nerdtree'

Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" Colorschemes
Plug 'chriskempson/base16-vim'
Plug 'arcticicestudio/nord-vim'
Plug 'nanotech/jellybeans.vim'
Plug 'zefei/cake16'

" Languages
"Plug 'fatih/vim-go'
"Plug 'rust-lang/rust.vim'

" Racket
Plug 'wlangstroth/vim-racket'
Plug 'MicahElliott/vrod'
Plug 'janko-m/vim-test'
Plug 'guns/vim-sexp'

call plug#end()

runtime! ftplugin/man.vim

" Plugin config
let g:test#racket#rackunit#file_pattern = '^.*test.*\.rkt$'
let g:is_chicken = 1

syntax on

set encoding=utf-8
set t_Co=256
set term=xterm-256color
set termencoding=utf-8
set fillchars+=stl:\ ,stlnc:\

set laststatus=2
"set statusline=[%n]\ %F\ %h%m%r%w\ %{fugitive#statusline()}\ %=%y\ [%{strlen(&fenc)?&fenc:&enc}]\ [%l:%c]\ %p%% 

set hlsearch
set incsearch
set smartcase

set number
set expandtab
set tabstop=4
set shiftwidth=4
set autoindent
set backspace=indent,eol,start

set list
set listchars=tab:▸\ ,eol:¬

set foldmethod=indent
set foldlevel=1
set nofoldenable

if has('gui_running')
	set guicursor+=a:blinkon0
	set guifont=Sauce\ Code\ Powerline:h14'
	set guioptions-=r
	set transparency=0
endif
set mouse=a

set background=dark
"let base16colorspace=256
"colorscheme base16-ocean
let g:jellybeans_overrides = { 'background': { 'ctermbg': 'none', '256ctermbg': 'none' }, }
colorscheme jellybeans

set laststatus=0
"hi Normal ctermbg=NONE
"hi LineNr ctermbg=NONE

let mapleader=","
nnoremap <leader>f :NERDTreeToggle<CR>
nnoremap <leader>t :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>s :Tags<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>m :make<CR>
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)

