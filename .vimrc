" --- Cardea Vim Core Config (Vim 9.2 compatible) ---
" Copyright Ernesto Celis <ecelis@sdf.org>
"
" --- Cardea Cross-Platform Logic ---
let g:is_freebsd = has("freebsd")
let g:is_linux = has("unix") && !has("freebsd") && !has("mac")

if g:is_freebsd
    " FreeBSD specific: Ensure we use the correct path for system binaries
    set shell=/usr/local/bin/bash
    let g:sqlite_clib_path = '/usr/local/lib/libsqlite3.so' " Useful for some plugins
elseif g:is_linux
    " Fedora specific: Standard Linux paths
    set shell=/bin/bash
endif

" Cross-platform Clipboard handling
if has('unnamedplus')
    set clipboard=unnamedplus
endif

" --- Cardea Dual-Mode Logic ---
" Detect if we were invoked as 'vi'
let g:is_retro_mode = (v:progname ==# 'vi')

" 2. Plugin List
if !g:is_retro_mode
    " 1. Automatic Plugin Manager Installation (vim-plug)
    let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
    if empty(glob(data_dir . '/autoload/plug.vim'))
      silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

    call plug#begin()
        " The Essentials (Cardea Legacy Successors)
        Plug 'tpope/vim-sensible'          " Sane defaults everyone agrees on
        Plug 'tpope/vim-fugitive'          " The gold standard for Git
        Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy finder binary
        Plug 'junegunn/fzf.vim'            " FZF Vim integration (replaces CtrlP)
        Plug 'preservim/nerdtree'          " File tree (The Cardea classic)
        Plug 'dense-analysis/ale'          " Async Linting (replaces Syntastic)
        
        " Modern Intelligence
        Plug 'neoclide/coc.nvim', {'branch': 'release'} " LSP support (for Go/Python/C)
        
        " Aesthetics
        Plug 'itchyny/lightline.vim'       " Lightweight status line
        Plug 'sainnhe/gruvbox-material'    " Clean, professional retro-vibe theme
    call plug#end()
endif

" 3. Sane Defaults
set nocompatible            " Break away from old Vi behavior
set encoding=utf-8
set hidden
set number relativenumber   " Hybrid line numbers (great for 'jump' commands)
set splitbelow splitright   " Logical window splitting
set expandtab
set shiftwidth=4
set tabstop=4
set smartindent
set clipboard=unnamedplus   " Use system clipboard
if g:is_retro_mode
    " Retro Mode: Pure, fast, and distraction-free
    set nocompatible
    set laststatus=0      " Hide status bar
    set noshowmode        " Hide mode indicator (classic feel)
    set noruler           " Hide cursor position
    set nonumber          " No line numbers
    set mouse=            " Disable mouse
    " Disable all modern plugins for this session
    let g:loaded_coc_nvim = 1
    let g:loaded_nerdtree = 1
    let g:loaded_fzf = 1
else
    " Modern Mode: Full IDE-lite features
    set updatetime=300          " Faster completion and diagnostics (for CoC)
    set signcolumn=yes          " Always show the gutter to prevent 'shifting'
    set laststatus=2
    set number relativenumber
    set mouse=a
endif

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
if g:is_retro_mode
    " Retro Terminal Aesthetic
    autocmd ColorScheme * highlight Normal ctermbg=none guibg=black
    autocmd ColorScheme * highlight CursorLine ctermbg=233 guibg=#080808

    " Choose your Phosphor:
    " For Amber: guifg=#ffb000 | For Green: guifg=#33ff33
    autocmd VimEnter * highlight Normal guifg=#33ff33

    colorscheme default " Use the classic base
else
    " Modern Professional Aesthetic
    colorscheme gruvbox-material
endif
" let g:gruvbox_material_background = 'soft'
" colorscheme gruvbox-material

" 6. Basic Mappings (The 'Janos' Layer)
let mapleader = " "         " Space as leader is modern & ergonomic
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>g :G<CR>

" --- End Core Config ---

if !g:is_retro_mode
    " --- Cardea Intelligence (CoC/LSP) ---
    " Use tab for trigger completion with characters ahead and navigate.
    " --- Cardea Intelligence (Vim9 optimized) ---

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
endif

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

" --- Cardea Go Integration ---

" Auto-format and organize imports on save
autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')
autocmd BufWritePre *.go :silent call CocAction('format')

" Map :OR to manually organize imports if needed
command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add Go-specific status line info (Optional, requires lightline)
let g:lightline = {
  \ 'colorscheme': 'gruvbox_material',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'modified', 'method' ] ]
  \ },
  \ 'component_function': {
  \   'method': 'CocCurrentFunction'
  \ },
\ }
