" --- Cardea Vim Core Config (Vim 9.2 compatible) ---

" 1. Automatic Plugin Manager Installation (vim-plug)
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" 2. Plugin List
call plug#begin()
    " The Essentials (Janus Legacy Successors)
    Plug 'tpope/vim-sensible'          " Sane defaults everyone agrees on
    Plug 'tpope/vim-fugitive'          " The gold standard for Git
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy finder binary
    Plug 'junegunn/fzf.vim'            " FZF Vim integration (replaces CtrlP)
    Plug 'preservim/nerdtree'          " File tree (The Janus classic)
    Plug 'dense-analysis/ale'          " Async Linting (replaces Syntastic)
    
    " Modern Intelligence
    Plug 'neoclide/coc.nvim', {'branch': 'release'} " LSP support (for Go/Python/C)
    
    " Aesthetics
    Plug 'itchyny/lightline.vim'       " Lightweight status line
    Plug 'sainnhe/gruvbox-material'    " Clean, professional retro-vibe theme
call plug#end()

" 3. Sane Defaults
set nocompatible            " Break away from old Vi behavior
set encoding=utf-8
set number relativenumber   " Hybrid line numbers (great for 'jump' commands)
set splitbelow splitright   " Logical window splitting
set mouse=a                 " Enable mouse in all modes
set clipboard=unnamedplus   " Use system clipboard
set laststatus=2            " Always show status line
set updatetime=300          " Faster completion and diagnostics (for CoC)
set signcolumn=yes          " Always show the gutter to prevent 'shifting'

" 4. Indentation (Standard SE defaults)
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set smartindent

" 5. Visuals & Theme
if has('termguicolors')
  set termguicolors
endif
let g:gruvbox_material_background = 'soft'
colorscheme gruvbox-material

" 6. Basic Mappings (The 'Janos' Layer)
let mapleader = " "         " Space as leader is modern & ergonomic
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>g :G<CR>

" --- End Core Config ---

" --- Cardea Intelligence (CoC/LSP) ---

" Use tab for trigger completion with characters ahead and navigate.
" --- Janos Intelligence (Vim9 optimized) ---

def CheckBackSpace(): bool
  var col = col('.') - 1
  return col == 0 || getline('.')[col - 1] =~ '\s'
enddef

inoremap <silent><expr> <TAB>
            \ coc#pum#visible() ? coc#pum#next(1) :
            \ CheckBackSpace() ? "\<Tab>" :
            \ coc#refresh()
" inoremap <silent><expr> <TAB>
"      \ coc#pum#visible() ? coc#pum#next(1) :
"      \ check_back_space() ? "\<Tab>" :
"      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" function! check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming (Refactoring)
nmap <leader>rn <Plug>(coc-rename)

" --- End Intelligence ---

" Auto-open NERDTree if no files are specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Close Vim if the only window left open is NERDTree
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Auto-open NERDTree if no files are specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Close Vim if the only window left open is NERDTree
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
