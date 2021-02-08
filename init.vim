"set nocompatible              " be iMproved, required
filetype off                  " required
filetype plugin on
syntax on

let mapleader = 'z'
let maplocalleader = 'z'

" Keep Plugin commands between vundle#begin/end.
"Plugin 'tpope/vim-fugitive'
"Plugin 'w0rp/ale'
"Plugin 'leafgarland/typescript-vim'
"Plugin 'Quramy/tsuquyomi'
"Plugin 'Shougo/vimproc.vim'
"Plugin 'davidhalter/jedi-vim'
"Plugin 'kien/ctrlp.vim'
"Plugin 'fatih/vim-go'
"Plugin 'pangloss/vim-javascript'
"Plugin 'mxw/vim-jsx'
"Plugin 'skywind3000/asyncrun.vim'

" Plugins here
"
call plug#begin('~/.config/nvim/plugged')
" Autocomplete stuff
"Plug 'Valloric/YouCompleteMe'
Plug 'davidhalter/jedi-vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'ervandew/supertab'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'
"Plug 'vim-syntastic/syntastic'
"Plug 'Chiel92/vim-autoformat'
Plug 'scrooloose/nerdtree'
Plug 'terryma/vim-multiple-cursors'
Plug 'vimwiki/vimwiki'

" Javascript & web plugins
Plug 'mattn/emmet-vim'
Plug 'pangloss/vim-javascript'      "javascript syntax support
Plug 'mxw/vim-jsx'                  " jsx syntax support
Plug 'Valloric/MatchTagAlways'      "html tag highlight and tab
Plug 'maksimr/vim-jsbeautify'

" golang plugins
Plug 'fatih/vim-go'

Plug 'tpope/vim-surround'           "surround plugin

" Snippets plugins
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets' " Snippets are separated from the engine. Add this if you want them:
Plug 'epilande/vim-react-snippets'

Plug 'ctrlpvim/ctrlp.vim' " search for file plugin
"Plug 'majutsushi/tagbar' " tag navbar

Plug 'tpope/vim-unimpaired' " [ ] key bindings

Plug 'google/yapf', { 'rtp': 'plugins/vim', 'for': 'python' }

call plug#end()


" All of your Plugins must be added before the following line
filetype plugin indent on    " required

set nu
set rnu
set autoindent
set showmode
set colorcolumn=100
set ruler
set hidden  " manage buffers more liberarly

"color molokai_dark
set termguicolors
colorscheme NeoSolarized
set background=dark
set bg=dark
set backspace=2
set autowrite

"set guifont=Inconsolata\ for\ Powerline:h24
set cursorline    " highlight the current line
set visualbell    " stop that ANNOYING beeping

"Allow usage of mouse in iTerm
set ttyfast
set mouse=a

" Make searching better
set gdefault      " Never have to type /g at the end of search / replace again
set ignorecase    " case insensitive searching (unless specified)
set hlsearch

set tabstop=4
set shiftwidth=4    " Indents will have a width of 4
set softtabstop=4   " Sets the number of columns for a TAB
set expandtab       " Expand TABs to spaces
set ls=4

set noswapfile " no dot backups
set nobackup
set smartcase " case sensitive search when pattern

set magic " Use 'magic' patterns (extended regular expressions).

"HTML Editing
set matchpairs+=<:>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

"Use enter to create new lines w/o entering insert mode
nnoremap <CR> o<Esc>

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

"Use tab to jump between blocks, because it's easier
nnoremap <tab> %
vnoremap <tab> %

"autocomplete
" inoremap <buffer> <C-Space> <C-X><C-O>
let g:jedi#completions_enabled = 0
let g:deoplete#enable_at_startup = 1
let g:SuperTabMappingForward = '<s-tab>'
let g:SuperTabMappingBackward = '<tab>'

" auto open nerdtree upon start
autocmd vimenter * NERDTree

" Save whenever switching windows or leaving vim. This is useful when running
" " the tests inside vim without having to save all files first.
au FocusLost,WinLeave * :silent! wa

" " automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

nnoremap <C-b> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['_site']
" enable line numbers
let NERDTreeShowLineNumbers=1
" make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber

" exit terminal on esc
tnoremap <Esc> <C-\><C-n>

" move to enclosing html tab
nnoremap <leader><tab> :MtaJumpToOtherTag<cr>

" command line / ex mode bindings
" %% expand to dir of current file
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
"syntastic settings
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 1

"let g:syntastic_typescript_tsc_fname = ''
"let g:syntastic_typescript_checkers = ['eslint', 'tslint']
"let g:syntastic_javascript_checkers = ['eslint']
"let g:syntastic_python_checkers = ['python']
"let g:typescript_compiler_binary = 'tsc'
"let g:typescript_compiler_options = ''
"let g:syntastic_html_checkers = [] " find angular linter!
"autocmd QuickFixCmdPost [^l]* nested cwindow
"autocmd QuickFixCmdPost    l* nested lwindow

"tsuquyomi
"autocmd FileType typescript setlocal completeopt+=menu,preview

"emmet
let g:user_emmet_leader_key='<C-y>'
"let g:user_emmet_leader_key='<Tab>'
let g:user_emmet_settings = {
\  'javascript.jsx' : {
\      'extends' : 'jsx',
\  },
\}

autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript


let wiki = {}
let wiki.path = '~/vimwiki/'
let wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'js': 'javascript'}
let g:vimwiki_list = [wiki]

" remove mvim lag
"set noshowcmd
"set nolazyredraw

"Ale config
let g:ale_sign_error = '●' " Less aggressive than the default '>>'
let g:ale_sign_warning = '.'
let b:ale_fixers = {'javascript': ['prettier', 'eslint'], 'python': ['pylint']}

"autorun prettier
"autocmd BufWritePost *.js AsyncRun -post=checktime ./node_modules/.bin/eslint --fix %

"" script for making * and # search for visual selection in visual mode
xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

function! s:VSetSearch(cmdtype)
	let temp = @s
	norm! gv"sy
	let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
endfunction

" clear highlight search
nnoremap <leader>l :<C-u>nohlsearch<CR><C-l>

" ctag reindex
nnoremap <leader>k :!ctags -R .<CR>
nmap <leader>i <C-]>
set tags=./tags,tags,.git/tags

" ctrlp settings
let g:ctrlp_custom_ignore = {
  \ 'dir': '\v[\/](landing-page|cryptosignals|bower_components|node_modules|DS_Store|pkg|build|bin)'
  \ }
nnoremap <leader>p :CtrlPBuffer<CR>
nnoremap <leader>t :CtrlPTag<cr>

" tagbar settings
nnoremap <C-n> :TagbarToggle<CR>

" ultisnips tab
let g:UltiSnipsExpandTrigger="<C-l>"
let g:UltiSnipsJumpForwardTrigger="<C-k>"
let g:UltiSnipsJumpBackwardTrigger="<C-j>"

" unimpaired bindings
nmap < [
nmap > ]
omap < [
omap > ]
xmap < [
xmap > ]
nnoremap § < 
nnoremap ° > 
vnoremap § < 
vnoremap ° > 
xnoremap § < 
xnoremap ° > 

" js beautify
map <c-f> :call JsBeautify()<cr>
let g:editorconfig_Beautifier = "~/.config/nvim/.editorconfig"

" yapf settings
nmap <Leader>y :YAPF<CR>:w<CR>

"  Outside colorscheme switch
nmap <Leader>o :set background=light<CR>:colorscheme PaperColor<CR>
nmap <Leader>i :set background=dark<CR>:colorscheme NeoSolarized<CR>

" Python installation
let g:python_host_prog = '/anaconda/envs/neovim2/bin/python'
let g:python3_host_prog = '/anaconda/envs/py36/bin/python'
