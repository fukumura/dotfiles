syntax on
set hidden
set wildmenu
set nocompatible

" for vundle
set rtp+=~/.vim/vundle/
call vundle#rc()
filetype plugin on

Bundle 'Shougo/unite.vim'
Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/vimfiler'
Bundle 'chrismetcalf/vim-yankring'
Bundle 'scrooloose/nerdcommenter'
Bundle 'tpope/vim-surround'
Bundle 'thinca/vim-quickrun'
Bundle 'thinca/vim-ref'
Bundle 'kana/vim-fakeclip'
Bundle 'mattn/zencoding-vim'
Bundle 'JavaScript-syntax'
Bundle 'itspriddle/vim-javascript-indent'
Bundle 'hotchpotch/perldoc-vim'
Bundle 'petdance/vim-perl'
Bundle 'cakephp.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'NERD_tree_ACK.vim'

" /for vundle

"" 表示系
set number
set tabstop=4
set expandtab
set scrolloff=5
set showmatch
set showcmd
set list
set listchars=tab:>-
set laststatus=2
set statusline=%<%F\ %r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%4v(ASCII=%03.3b,HEX=%02.2B)\ %l/%L(%P)%m

set showtabline=2
nnoremap <Space>t t
nnoremap <Space>T T
nnoremap t <Nop>
nnoremap <silent> tc :<C-u>tabnew<LF>:tabmove<LF>
nnoremap <silent> tk :<C-u>tabclose<LF>
nnoremap <silent> tn :<C-u>tabnext<LF>
nnoremap <silent> tp :<C-u>tabprevious<LF>

"status line changes background color when it is insert mode
let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'

if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction


" 保存時に行末の空白を除去する
autocmd BufWritePre * :%s/\s\+$//ge
" " 保存時にtabをスペースに変換する
autocmd BufWritePre * :%s/\t/  /ge
"compliler
autocmd FileType perl,cgi :compiler perl

"compliler:perl
au BufReadPost,BufNewFile *.t :setl filetype=perl

nnoremap <C-B> :NERDTreeToggle<Return>

" 検索
set ignorecase
set smartcase
set noincsearch
set hlsearch
nmap <Esc><Esc> :nohlsearch<LF><Esc>

set backspace=indent,eol,start


if has("syntax")
    syntax on
    function! ActivateInvisibleIndicator()
        syntax match InvisibleJISX0208Space "　" display containedin=ALL
        highlight InvisibleJISX0208Space term=underline ctermbg=Blue guifg=#999999 gui=underline
        syntax match InvisibleTrailedSpace "[ ]\+$" display containedin=ALL
        highlight InvisibleTrailedSpace term=underline ctermbg=Red guifg=#FF5555 gui=underline
        syntax match InvisibleTab "\t" display containedin=ALL
        highlight InvisibleTab term=underline ctermbg=Cyan guibg=#555555
    endf
    augroup invisible
        autocmd! invisible
        autocmd BufNew,BufRead * call ActivateInvisibleIndicator()
    augroup END
endif

autocmd FileType php set tags=$HOME/.vim/tags/perl.tags,$HOME/.vim/tags/perl_app.tags
nmap ,U :set encoding=utf-8<LF>
nmap ,E :set encoding=euc-jp<LF>
map ,S :set encoding=cp932<LF>

" unite.vim
let g:unite_source_file_mru_time_format = ''
let g:unite_enable_split_vertically=1
let g:unite_enable_start_insert = 1
let g:unite_source_file_mru_ignore_pattern='.*\/$\|.*Application\ Data.*'

autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
  imap <buffer> jj <Plug>(unite_insert_leave)
  imap <buffer> <C-j> <Plug>(unite_exit)
  imap <buffer> <ESC> <Plug>(unite_exit)
  imap <buffer> <C-o> <Plug>(unite_insert_leave):<C-u>call unite#mappings#do_action('above')<LF>
endfunction

autocmd FileType vimshell call s:vimshell_my_settings()
function! s:vimshell_my_settings()
  inoremap <buffer> <C-x> <ESC><C-w>h:on<LF>
  inoremap <buffer> <silent> <C-n>  <ESC>:<C-u>Unite buffer <LF>
  inoremap <buffer> <silent> <C-r>  <ESC>:<C-u>Unite file_mru <LF>
  nnoremap <buffer> <LF> Go$
  imap <buffer> <C-x>     <ESC><C-w>h:on<LF>
  nnoremap <buffer><silent> <C-n>  :<C-u>Unite buffer <LF>
  inoremap <C-v> <C-R>+
  inoremap <buffer><expr><C-h> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
  imap <buffer> <C-o> <Plug>(vimshell_enter)
  inoremap <buffer> <C-l> <C-y>
  imap <buffer> <C-s> <Plug>(vimshell_history_complete_whole)
  NeoComplCacheAutoCompletionLength 3
endfunction
" バッファ一覧
noremap <silent> <C-U><C-B> :Unite buffer<LF>
" ファイル一覧
noremap <silent> <C-U><C-F> :UniteWithBufferDir -buffer-name=files file<LF>
" レジスタ一覧
noremap <silent> <C-U><C-R> :Unite -buffer-name=register register<LF>
" 最近使用したファイル一覧
noremap <silent> <C-U><C-M> :Unite file_mru<LF>
" 常用セット
noremap <silent> <C-U><C-Y> :Unite buffer file_mru<LF>
" 全部乗せ
noremap <silent> <C-U><C-M> :UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<LF>
" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> q
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>q

"neocomplcache(http://vim-users.jp/2010/10/hack177/)
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
let g:neocomplcache_snippets_dir = $HOME.'/.vim/snippets'

"vimfilter
"let g:vimfiler_as_default_explorer = 1

