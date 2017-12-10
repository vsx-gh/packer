" .vimrc file created 20150606 JV

syntax on
"syntax enable
filetype on
colorscheme molokai
filetype indent plugin on
set number
set ruler
set showcmd         " show command in bottom bar
set showmatch       " highlight matching brackets, etc
set showmode
set incsearch
set hlsearch
set autoindent
"filetype indent on  " load filetype-specific indent files
set smarttab
set tabstop=4
set softtabstop=4   " number of spaces in tab when editing
set expandtab       " tabs are spaces
set shiftwidth=4
nnoremap <leader><space> :nohlsearch<CR>
set foldmethod=indent
set foldignore=
set laststatus=2
set statusline=[%n]\ %<%F\ \ \ [%M%R%H%W%Y][%{&ff}]\ \ %=\ line:%l/%L\ col:%c\ \ \ %p%%\ \ \ %{strftime(\"%H:%M\")}
set foldlevelstart=5
"autocmd Filetype python setlocal ts=4 sts=4 sw=4 expandtab autoindent smarttab
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
set modeline
