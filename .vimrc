"" =============================================================================
" CARDEA VIM CONFIGURATION (v1.0)
" The Functional Successor to Janus | Optimized for Vim 9.2
" Copyright Ernesto Celis <ecelis@sdf.org>
" =============================================================================

" --- 1. ENVIRONMENT & HINGE LOGIC ---
let g:is_freebsd = has("freebsd")
let g:is_linux = has("unix") && !has("freebsd") && !has("mac")
let g:is_retro_mode = (v:progname ==# 'vi')

if g:is_freebsd
    set shell=/usr/local/bin/bash
elseif g:is_linux
    set shell=/bin/bash
endif

function! CardeaProjectStatus()
    let l:status = []

    " Get Git Branch
    let l:branch = system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
    if !empty(l:branch)
        call add(l:status, "   🌿 Git Branch: " . l:branch)
    endif

    " Detect Project Type
    if filereadable('go.mod')
        let l:go_version = system("go version | awk '{print $3}' | tr -d '\n'")
        call add(l:status, "   🐹 Go Project (" . l:go_version . ")")
    elseif isdirectory('.venv') || exists('$VIRTUAL_ENV')
        let l:venv = exists('$VIRTUAL_ENV') ? substitute($VIRTUAL_ENV, '.*/', '', '') : ".venv"
        call add(l:status, "   🐍 Python Env: " . l:venv)
    endif

    return l:status
endfunction

" --- 2. BOOTSTRAP PLUGIN MANAGER ---
if !g:is_retro_mode
    let data_dir = expand('~/.vim')
    if empty(glob(data_dir . '/autoload/plug.vim'))
      echo "Cardea: Bootstrapping plugin manager..."
      silent execute '!curl -fLo ' . data_dir . '/autoload/plug.vim --create-dirs ' .
        \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

    call plug#begin('~/.vim/plugged')
        " Essentials & UI
        Plug 'tpope/vim-sensible'
        Plug 'tpope/vim-fugitive'
        Plug 'tpope/vim-commentary'
        Plug 'mhinz/vim-startify'
        Plug 'itchyny/lightline.vim'

        " Navigation
        Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
        Plug 'junegunn/fzf.vim'
        Plug 'preservim/nerdtree'

        " Intelligence & Formatting
        Plug 'neoclide/coc.nvim', {'branch': 'release'}
        Plug 'dense-analysis/ale'

        " Themes
        Plug 'ghifarit53/tokyonight-vim'
        Plug 'sainnhe/gruvbox-material'
    call plug#end()
endif

" --- 3. SANE DEFAULTS ---
set nocompatible
set encoding=utf-8
set hidden
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes
set splitbelow splitright
set expandtab
set shiftwidth=4
set tabstop=4
set smartindent
set textwidth=72

" --- 4. DUAL-MODE VISUALS (Safe Load) ---
if g:is_retro_mode
    " Retro Face: Distraction-free Phosphor Green
    set laststatus=0
    set nonumber
    set mouse=
    autocmd VimEnter * highlight Normal guifg=#33ff33 guibg=black
else
    " Modern Face: Tokyo Night Default
    set laststatus=2
    set number relativenumber
    set mouse=a
    set clipboard=unnamedplus
    set termguicolors

    if isdirectory(expand("~/.vim/plugged/tokyonight-vim"))
        let g:tokyonight_style = 'night'
        let g:tokyonight_enable_italic = 1
        colorscheme tokyonight
    else
        colorscheme industry
    endif
endif


" --- 5. KEYBINDINGS (Leader = Space) ---
let mapleader = " "
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>g :G<CR>
nnoremap <leader>w gqap
vnoremap <leader>w gq
nnoremap <leader>tw :set wrap!<CR>

" Theme Toggle Logic
function! ToggleTheme()
    if (exists('g:colors_name') && g:colors_name == 'tokyonight')
        let g:gruvbox_material_background = 'soft'
        colorscheme gruvbox-material
        let g:lightline.colorscheme = 'gruvbox_material'
    else
        colorscheme tokyonight
        let g:lightline.colorscheme = 'tokyonight'
    endif
    call lightline#init() | call lightline#colorscheme() | call lightline#update()
endfunction
nnoremap <leader>t :call ToggleTheme()<CR>

" --- 6. INTELLIGENCE & AUTOCOMPLETE ---
if !g:is_retro_mode
    " Tab and Enter behavior
    inoremap <silent><expr> <TAB>
          \ coc#pum#visible() ? coc#pum#next(1) :
          \ CheckBackSpace() ? "\<Tab>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
    inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    function! CheckBackSpace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " LSP Navigation & Docs
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gr <Plug>(coc-references)
    nnoremap <silent> K :call ShowDocumentation()<CR>
    function! ShowDocumentation()
      if CocAction('hasProvider', 'hover') | call CocActionAsync('doHover')
      else | call feedkeys('K', 'in') | endif
    endfunction

    " Hover Window Scrolling
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

    " Highlights & Automation
    autocmd CursorHold * if exists('*CocActionAsync') | silent call CocActionAsync('highlight') | endif
    autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')
    autocmd BufWritePre *.go :silent call CocAction('format')
endif

" --- 7. START SCREEN & SESSIONS ---
"  " --- 4. DUAL-MODE VISUALS (Fixed Lightline Sync) ---
if g:is_retro_mode
    set laststatus=0 | set nonumber | set mouse=
    autocmd VimEnter * highlight Normal guifg=#33ff33 guibg=black
else
    set laststatus=2 | set number relativenumber | set mouse=a
    set clipboard=unnamedplus | set termguicolors

    if isdirectory(expand("~/.vim/plugged/tokyonight-vim"))
        let g:tokyonight_style = 'night'
        colorscheme tokyonight
        " Explicitly set lightline theme to match
        let g:lightline = {'colorscheme': 'tokyonight'}
    else
        colorscheme industry
    endif
endif

" --- 7. START SCREEN (Startify) ---
" --- Cardea Dashboard Builder ---

function! CardeaBuildHeader()
    " The static ASCII art
    let l:header = [
          \ '   _____               _                ',
          \ '  / ____|             | |               ',
          \ ' | |     __ _ _ __  __| | ___  __ _     ',
          \ ' | |    / _` | ''__|/ _` |/ _ \/ _` |    ',
          \ ' | |___| (_| | |  | (_| |  __/ (_| |    ',
          \ '  \_____\__,_|_|   \__,_|\___|\__,_|    ',
          \ '                                        ',
          \ '   Janus watches; Cardea moves the hinge.',
          \ '   --------------------------------------',
          \ ]

    " Get Git Branch
    let l:branch = system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
    if !empty(l:branch)
        call add(l:header, "   🌿 Git Branch: " . l:branch)
    endif

    " Detect Project Type
    if filereadable('go.mod')
        let l:go_version = system("go version | awk '{print $3}' | tr -d '\n'")
        call add(l:header, "   🐹 Go Project (" . l:go_version . ")")
    elseif isdirectory('.venv') || exists('$VIRTUAL_ENV')
        let l:venv = exists('$VIRTUAL_ENV') ? substitute($VIRTUAL_ENV, '.*/', '', '') : ".venv"
        call add(l:header, "   🐍 Python Env: " . l:venv)
    endif

    return l:header
    "let g:startify_custom_header = s:header + CardeaProjectStatus()
endfunction

" Now assign the function result to Startify
if !g:is_retro_mode
    let g:startify_custom_header = CardeaBuildHeader()
    let g:startify_custom_footer = [
              \ '',
              \ '   Vim is Charityware. Please read ":help uganda" for details.',
              \ '   In memory of Bram Moolenaar, the creator of Vim.',
              \ '   Maintainer: ecelis | Cardea v1.0',
              \ ]
        " Smart NERDTree Launch (Ensures Startify is visible first)
    autocmd VimEnter * if argc() > 0 && !exists("s:std_in") | NERDTree | wincmd p | endif

endif
