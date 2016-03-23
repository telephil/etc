set nocompatible              " be iMproved, required

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'ctrlp.vim'

" Colorschemes
Plug 'chriskempson/base16-vim'

" Languages
Plug 'fatih/vim-go'
Plug 'rust-lang/rust.vim'

call plug#end()

syntax on

set encoding=utf-8
set t_Co=256
set term=xterm-256color
set termencoding=utf-8
set fillchars+=stl:\ ,stlnc:\

set laststatus=2
set statusline=[%n]\ %F\ %h%m%r%w\ %{fugitive#statusline()}\ %=%y\ [%{strlen(&fenc)?&fenc:&enc}]\ [%l:%c]\ %p%% 

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
	set transparency=7
endif
set mouse=a

set background=dark
let base16colorspace=256
colorscheme base16-default


