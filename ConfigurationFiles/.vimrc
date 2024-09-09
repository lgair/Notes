set nocompatible              " Be iMproved, required
filetype off                  " Required

" Set data directory for plugins
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo ' . data_dir . '/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Set runtime path for Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Plugin management
Plugin 'VundleVim/Vundle.vim'
Plugin 'L9'
Plugin 'morhetz/gruvbox'
Plugin 'tpope/vim-fugitive'
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'sheerun/vim-polyglot'
Plugin 'jiangmiao/auto-pairs'
Plugin 'preservim/nerdtree'
Plugin 'preservim/tagbar'
Plugin 'dyng/ctrlsf.vim'
Plugin 'derekwyatt/vim-fswitch'
Plugin 'Valloric/YouCompleteMe'
Plugin 'plasticboy/vim-markdown'

call vundle#end()            " Required
filetype plugin indent on    " Required

" Set colorscheme
autocmd vimenter * ++nested colorscheme gruvbox
set background=dark

" Enable syntax highlighting
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_auto_insert_bullets = 1

" General settings
set autoindent
set textwidth=76
set expandtab
set shiftround
set shiftwidth=4
set tabstop=4
set smarttab

" Search settings
set incsearch
set hlsearch
autocmd CmdlineLeave /,? :nohlsearch
set ignorecase
set smartcase

" Encoding and display settings
set encoding=utf-8
set linebreak
set scrolloff=1
set sidescrolloff=5
syntax enable 
set wrap
set number
set laststatus=2
set ruler
set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
set cursorline
set cursorcolumn
set noerrorbells
set title

" Backup settings
set backupdir=~/.cache/vim
set dir=~/.cache/vim
set nospell
set autowrite
let @/ = ""

" Window settings
set splitbelow
set mouse=a
let g:AutoPairsShortcutToggle = '<C-P>'

" NERDTree settings
let NERDTreeShowBookmarks = 1
let NERDTreeShowHidden = 1
let NERDTreeShowLineNumbers = 0
let NERDTreeMinimalMenu = 1
let NERDTreeWinPos = "left"
let NERDTreeWinSize = 31
nmap <F2> :NERDTreeToggle<CR>

" Line number toggle
nnoremap <F3> :set invnumber invrelativenumber<CR>

" Tagbar settings
let g:tagbar_autofocus = 1
let g:tagbar_autoshowtag = 1
let g:tagbar_position = 'botright vertical'
nmap <F8> :TagbarToggle<CR>

" CtrlSF settings
let g:ctrlsf_backend = 'ack'
let g:ctrlsf_auto_close = { "normal":0, "compact":0 }
let g:ctrlsf_auto_focus = { "at":"start" }
let g:ctrlsf_auto_preview = 0
let g:ctrlsf_case_sensitive = 'smart'
let g:ctrlsf_default_view = 'normal'
let g:ctrlsf_regex_pattern = 0
let g:ctrlsf_position = 'right'
let g:ctrlsf_winsize = '46'
let g:ctrlsf_default_root = 'cwd'
nmap <C-F>f <Plug>CtrlSFPrompt
xmap <C-F>f <Plug>CtrlSFVwordPath
xmap <C-F>F <Plug>CtrlSFVwordExec
nmap <C-F>n <Plug>CtrlSFCwordPath
nnoremap <C-F>o :CtrlSFOpen<CR>
nnoremap <C-F>t :CtrlSFToggle<CR>
inoremap <C-F>t <Esc>:CtrlSFToggle<CR>

" File switch settings
au! BufEnter *.cpp let b:fswitchdst = 'hpp,h'
au! BufEnter *.h let b:fswitchdst = 'cpp,c'
nmap <C-Z> :vsplit <bar> :wincmd l <bar> :FSRight<CR>

" Command to wipe Vim's registers
command! WipeReg for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor
autocmd VimEnter * WipeReg

" Command to set bash_funcitons file as sh file type for syntax highlighting
autocmd BufRead,BufNewFile ~/.bash_functions set filetype=sh

" Git branch status in status line
augroup UPDATE_GITBRANCH
  autocmd!
  autocmd BufWritePre * :call UpdateGitBranch()
  autocmd BufReadPost * :call UpdateGitBranch()
  autocmd BufEnter * :call UpdateGitBranch()
augroup END

let b:gitparsedbranchname = ' '
function! UpdateGitBranch()
  let l:string = system("git -C ".expand("%:p:h")." rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
  let b:gitparsedbranchname = strlen(l:string) > 0 ? ''.l:string : ' '
endfunction

" Status line configuration
set statusline=
set statusline+=%#PmenuSel#
set statusline+=[%{b:gitparsedbranchname}]
set statusline+=%#LineNr#
set statusline+=%#CursorColumn#
set statusline+=\ %f
set statusline+=%m
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set laststatus=2

" YCM settings
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_enable_inlay_hints = 1
hi link YcmInlayHint Comment
nnoremap <silent> <localleader>h <Plug>(YCMToggleInlayHints)
