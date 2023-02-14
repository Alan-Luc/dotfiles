set number
set ambw=double
set mouse=a
set nocompatible
set autoread
set noshowmode
set background=dark
set laststatus=2
set t_Co=256
set nobackup
set nowritebackup
set updatetime=50
set signcolumn=yes
set is hls
set scrolloff=10
let mapleader = ","

" Vim-Plug settings
" run plug install if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	\| PlugInstall --sync | source $MYVIMRC
	\| endif

call plug#begin('~/.vim/plugged')
Plug 'junegunn/seoul256.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'
Plug 'sheerun/vim-polyglot'
Plug 'haya14busa/is.vim'
Plug 'osyo-manga/vim-over'
Plug 'dense-analysis/ale'
Plug 'miyakogi/conoline.vim'
Plug 'mbbill/undotree'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries'}
" Plug 'tpope/vim-endwise'
" Plug 'morhetz/gruvbox'
" Plug 'TheNiteCoder/mountaineer.vim'
" Plug 'tmsvg/pear-tree', {'branch': 'master'}
" Plug 'lambdalisue/fern.vim'
" Plug 'tpope/vim-rails'
" Plug 'vim-ruby/vim-ruby'
" Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
call plug#end()

" Convenient vim binds and re-binds "
nnoremap <silent><F2> :tabp<CR>
nnoremap <silent><F3> :tabn<CR>

" move up and down by a page and center cursor
" ty primeagen
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap <S-j> mzJ`z
nnoremap <n> nzzzv
nnoremap <N> Nzzzv
xnoremap <leader>p "_dP
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>
nnoremap <silent><leader>x <cmd>!chmod +x %<CR>


" move lines up and down
xnoremap <silent><S-j> :m '>+1<CR>gv=gv
xnoremap <silent><S-k> :m '<-2<CR>gv=gv

" copy to clipboard and copy last yank to clipboard
xnoremap <silent><F12> :w !xclip -selection clipboard<CR><CR>
nnoremap <silent><F11> :call system('xclip -selection clipboard', @0)<CR>

" OTHER Plugin settings "
" vim-over
nnoremap <silent><C-h> :OverCommandLine<CR>
" conoline settings
let g:conoline_auto_enable = 1
let g:conoline_use_colorscheme_default_normal=1

"let g:gruvbox_contrast_dark= "hard"
let g:seoul256_background = 233
colo seoul256

""ALE settings
let g:ale_sign_column_always=1
let g:ale_disable_lsp = 1

colorscheme seoul256

" lightline settings
let g:lightline = {
	\'colorscheme': 'seoul256',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'filename', 'gitbranch', 'readonly', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'FugitiveHead',
  \ },
  \ }

" FZF settings
nnoremap <C-f> :FZF<CR>
nnoremap <C-p> :Rg<CR>
nnoremap <leader>g :GFiles<CR>

" Undotree settings
nnoremap <silent><F5> :UndotreeToggle<CR>


" COC Settings "
" TODO: cleanup coc settings
let g:coc_default_semantic_highlight_groups = 1

" use <tab> to trigger completion and navigate to the next complete item
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <silent><expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() :
                                           \"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

let g:coc_snippet_next = '<C-j>'
let g:coc_snippet_prev = '<C-k>'
