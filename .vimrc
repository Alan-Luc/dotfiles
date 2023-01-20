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
set updatetime=300
set signcolumn=yes


" Vim-Plug settings
" run plug install if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	\| PlugInstall --sync | source $MYVIMRC
	\| endif

call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'TheNiteCoder/mountaineer.vim'
Plug 'junegunn/seoul256.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'
" Plug 'tmsvg/pear-tree', {'branch': 'master'}
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-vinegar'
Plug 'vim-ruby/vim-ruby'
Plug 'dense-analysis/ale'
Plug 'lambdalisue/fern.vim'
Plug 'miyakogi/conoline.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries'}
call plug#end()

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
  \   'gitbranch': 'FugitiveHead'
  \ },
  \ }

" FZF settings
nmap <C-f> :FZF<CR>
nmap <C-p> :Rg<CR>

" Convenient vim binds and re-binds"
nmap <F2> :tabp<CR>
nmap <F3> :tabn<CR>

" move up and down by a page and center cursor
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" move lines up and down
nnoremap <silent><C-Down> :m+<CR>
nnoremap <silent><C-Up> :m-2<CR>
inoremap <silent><C-Down> <Esc>:m+<CR>
inoremap <silent><C-Up> <Esc>:m-2<CR>

" copy to clipboard and copy last yank to clipboard
xnoremap <silent><F12> :w !xclip -selection clipboard<CR><CR>
nnoremap <silent><F11> :call system('xclip -selection clipboard', @0)<CR>


" COC Settings "
" TODO: cleanup coc settings

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
