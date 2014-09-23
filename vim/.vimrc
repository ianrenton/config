set number
set autoread
set ruler
set ignorecase
set smartcase
set hlsearch
set incsearch
syntax enable
colorscheme desert
set background=dark
set encoding=utf8
set nobackup
set nowb
set noswapfile
set expandtab
set smarttab
set ai
set si
set wrap
set shiftwidth=2
set tabstop=2

set laststatus=2
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h%=Line\ %l/%L\ \ Char\ %c\ 

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction
