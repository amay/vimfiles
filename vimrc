if has('vim_starting')
 if &compatible
   set nocompatible
 endif

 set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

let mapleader = " "

" NeoBundle
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc.vim', {
      \   'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'linux' : 'make',
      \     'unix' : 'gmake',
      \   }
      \ }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Include user's local vim bundles
" You can also override mapleader here
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable(expand("~/.vim_bundles.local"))
  source ~/.vim_bundles.local
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fugitive
" Git in vim, use ,gs for git status then - to stage then C to commit
" check :help Gstatus for more keys
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'tpope/vim-fugitive'

map <leader>gs :Gstatus<cr>
map <leader>gc :Gcommit<cr>
map <leader>ga :Git add --all<cr>:Gcommit<cr>
map <leader>gb :Gblame<cr>

" Use j/k in status
function! BufReadIndex()
  setlocal cursorline
  setlocal nohlsearch

  nnoremap <buffer> <silent> j :call search('^#\t.*','W')<Bar>.<CR>
  nnoremap <buffer> <silent> k :call search('^#\t.*','Wbe')<Bar>.<CR>
endfunction
autocmd BufReadCmd  *.git/index                      exe BufReadIndex()
autocmd BufEnter    *.git/index                      silent normal gg0j

" Start in insert mode for commit
function! BufEnterCommit()
  normal gg0
  if getline('.') == ''
    start
  end
endfunction
autocmd BufEnter    *.git/COMMIT_EDITMSG             exe BufEnterCommit()

" Automatically remove fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Surrond stuff with things. ysiw" surrounds a word with quotes
" cs"' changes " to '
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'tpope/vim-surround'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Lets you use . to repeat some things like vim-surround
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'tpope/vim-repeat'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Comment with gc (takes a motion) or ^_^_
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'tomtom/tcomment_vim'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CtrlP
"
" Open a file (like cmd-t but better). Use ,f or ,j(something, see bindings
" below)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'JazzCore/ctrlp-cmatcher', {
      \   'build' : {
      \     'windows' : 'install_windows.bat',
      \     'mac' : './install.sh',
      \     'linux' : './install.sh',
      \     'unix' : './install.sh',
      \    }
      \  }

" Don't manage working directory
let g:ctrlp_working_path_mode = 0

if executable('ag')
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s --files-with-matches --nocolor -g "" --ignore "\.git$\|\.hg$\|\.svn$"'
else
  " Fall back to using git ls-files if Ag is not available
  let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others']
endif

map <leader>jv :let g:ctrlp_default_input = 'app/views/'<cr>:CtrlP<cr>
map <leader>jc :let g:ctrlp_default_input = 'app/controllers/'<cr>:CtrlP<cr>
map <leader>jm :let g:ctrlp_default_input = 'app/models/'<cr>:CtrlP<cr>
map <leader>jh :let g:ctrlp_default_input = 'app/helpers/'<cr>:CtrlP<cr>
map <leader>jl :let g:ctrlp_default_input = 'lib'<cr>:CtrlP<cr>
map <leader>jp :let g:ctrlp_default_input = 'public'<cr>:CtrlP<cr>
map <leader>js :let g:ctrlp_default_input = 'app/stylesheets/'<cr>:CtrlP<cr>
map <leader>jj :let g:ctrlp_default_input = 'app/javascripts/'<cr>:CtrlP<cr>
map <leader>jf :let g:ctrlp_default_input = 'features/'<cr>:CtrlP<cr>
map <leader>f :let g:ctrlp_default_input = 0<cr>:CtrlP<cr>
map <leader>u :let g:ctrlp_default_input = 0<cr>:CtrlPBuffer<cr>
map <leader><leader>f :let g:ctrlp_default_input = 0<cr>:CtrlPClearCache<cr>:CtrlP<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ack mappings
"
" Adds :Ack complete w/ quick fix
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'mileszs/ack.vim'

map <leader>a :Ack!<space>
map <leader>A :Ack! <C-R><C-W><CR>

" Use ag for search, it's much faster than ack.
" See https://github.com/ggreer/the_silver_searcher
" on mac: brew install the_silver_searcher
let g:ackprg = 'ag --nogroup --nocolor --column --smart-case'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Updates your status line to show what selector you're in in sass files
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'aaronjensen/vim-sass-status'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Kills a buffer without closing a split, use ,w . Used in conjunction 
" with command-w, below...
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'vim-scripts/bufkill.vim'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Command W
"
" Smarts around killing buffers, will close the split if it's the last buffer in
" it, and close vim if it's the last buffer/split. Use ,w
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'aaronjensen/vim-command-w'

nmap <leader>w :CommandW<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Shows syntax errors on several types of files
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'scrooloose/syntastic'

let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_filetype_map = { 'handlebars.html': 'handlebars' }
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': [],
                           \ 'passive_filetypes': ['sass'] }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Automatically add end at the end of ruby and vim blocks
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'tpope/vim-endwise'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Add a few paired mappings, in particular [q and ]q to navigate the quickfix
" list
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'tpope/vim-unimpaired'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Handy file manipulations. Favorites are :Remove and :Rename
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'tpope/vim-eunuch'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Allows custom textobj motions (like i" or a[)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'kana/vim-textobj-user'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Motion based on indent level. Useful in coffeescript, try vai to select
" everything on the current indent level. vii is similar, but will not ignore
" blank lines
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'kana/vim-textobj-indent'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Motion based on ruby blocks. vir selects in a ruby block
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'nelstrom/vim-textobj-rubyblock'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tab to indent or autocomplete depending on context
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'ervandew/supertab'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Run specs or cucumber features with ,t run only the test under the cursor
" with ,T also remembers last run test so you can hit it again on non-test
" files to run the last run test
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'skalnik/vim-vroom'

let g:vroom_map_keys = 0
let g:vroom_write_all = 1
let g:vroom_use_bundle_exec = 0
let g:vroom_use_spring = 1
map <leader>t :VroomRunTestFile<cr>
map <leader>T :VroomRunNearestTest<cr>
" autocmd BufNewFile,BufRead *_spec.js.coffee map <buffer> <leader>t :!guard-jasmine -s=none -p=3000 %<cr>
autocmd BufNewFile,BufRead *_spec.js.coffee map <buffer> <leader>t :!spring teaspoon --server-port 3000 -g $(cat % \| grep -m 1 describe \| sed "s/describe ['\"]\(.*\)['\"].*/\1/")<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim coffeescript runtime files
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'kchmck/vim-coffee-script'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" JSX syntax highlighting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'mxw/vim-jsx'
NeoBundle 'mtscout6/vim-cjsx'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Stuff for cucumber, try out ^] on a step in a feature to go to step
" definition
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'tpope/vim-cucumber'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Updated ruby syntax and such
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'vim-ruby/vim-ruby'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Improved javascript indentation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'pangloss/vim-javascript'

autocmd BufNewFile,BufRead *._js set filetype=javascript

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Git runtime files
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'tpope/vim-git'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim runtime files for Haml, Sass, and SCSS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'tpope/vim-haml'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim syntax for LESS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'groenewege/vim-less'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Markdown runtime files
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'tpope/vim-markdown'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim handlebars runtime files
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'nono/vim-handlebars'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntax for jquery keywords and selectors
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'itspriddle/vim-jquery'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim syntax for jst files
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'jeyb/vim-jst'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntax for nginx
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'mutewinter/nginx.vim'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntax for jade/blade
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'digitaltoad/vim-jade'
autocmd BufNewFile,BufReadPost *.blade set filetype=jade

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Makes css colors show up as their actual colors, works better with CSApprox
" or macvim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'ap/vim-css-color'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" My favorite dark color scheme
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'tomasr/molokai'
let g:rehash256 = 1
let g:molokai_original = 1
set t_Co=256

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Decent light color scheme
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'nelstrom/vim-mac-classic-theme'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Powerline
"
" The ultimate vim statusline utility
"
" You'll need a powerline patched font.
" You should probably use inconsolata-g (included in fonts directory)
"
" If not, you can patch your own.
" See: https://github.com/Lokaltog/vim-powerline/tree/develop/fontpatcher
" You'll probably need this too: https://github.com/jenius/Fontforge-Installer
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'Lokaltog/vim-powerline'

let g:Powerline_symbols = 'fancy'
let g:Powerline_stl_path_style = 'relative'
" call Pl#Theme#RemoveSegment('fugitive:branch')
" call Pl#Theme#RemoveSegment('fileformat')
" call Pl#Theme#RemoveSegment('fileencoding')
" call Pl#Theme#RemoveSegment('scrollpercent')
autocmd FocusGained * call Pl#UpdateStatusline(1)
autocmd FocusLost * call Pl#UpdateStatusline(0)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" makes the command line behave like emacs
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'houtsnip/vim-emacscommandline'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Adds gr command to replace text (takes a motion)
" similar to v(motion)p but also cuts text into black hole register so it is
" repeatable. So really it's similar to v(motion)"_p
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'ReplaceWithRegister'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use :BufOnly (or :BO) to close all buffers except current
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'duff/vim-bufonly'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" matchindent.vim
"
" Attempt to guess and automatically set the indentation settings of the
" opened file. Works for " 2 space, 4 space and tab indentation.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'conormcd/matchindent.vim'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vitality.vim
"
" Add FocusGained/FocusLost back.
" Requires features in HEAD tmux.
"
" Using my branch until tmux supports this in a released version.
" Also this should make it so that anyone else who uses this w/o
" the right version of tmux will be fine.
" https://github.com/aaronjensen/vitality.vim/commit/3308bf21fb3d46d55ca84a19d228f8cf2210679d
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'aaronjensen/vitality.vim'
let g:vitality_fix_focus = 1
let g:vitality_fix_cursor = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-marked
"
" Opens current file in Marked, an OSX markdown preview app:
" http://markedapp.com/
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'itspriddle/vim-marked'

let g:marked_app = "Marked"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-velocity
"
" Support for java velocity templates.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'lepture/vim-velocity'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Clojure stuff
"
" http://clojure-doc.org/articles/tutorials/vim_fireplace.html
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Clojure REPL
"
" You'll want to install https://github.com/clojure-emacs/cider-nrepl
"
" cq - Clojure Quasi-REPL
" cqq - Populate REPL w/ current expression
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'tpope/vim-fireplace'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Leiningen stuff
"
" :Console
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'tpope/vim-leiningen'
NeoBundle 'tpope/vim-dispatch'

call neobundle#end()
NeoBundleCheck

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

:runtime macros/matchit.vim

filetype plugin indent on

" Backups and swap
set nobackup
set nowritebackup
set noswapfile
set backupdir=~/.vim/backup
set directory=~/.vim/backup


syntax on
set nohidden
set history=10000
set number
set ruler
set switchbuf=useopen
set encoding=utf-8

" Whitespace stuff
set nowrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set list listchars=tab:\ \ ,trail:·

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Tab completion
set wildmode=longest,list
set wildmenu
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*,*/public/javascripts/compiled
set wildignore+=tmp,*.orig,*.jpg,*.png,*.gif,log,solr,.sass-cache,.jhw-cache
set wildignore+=bundler_stubs,build,error_pages,bundle,build,error_pages,target,node_modules,bower_components
set wildignore+=*/app/public/compiled,*/public/compiled,*/tmp,compiled
set wildignore+=vendor

" Status bar
set laststatus=2

" h/l wrap to prev/next line
set whichwrap=h,l

" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
" set t_ti= t_te=

let g:CSApprox_attr_map = { 'bold' : 'bold', 'italic' : '', 'sp' : '' }
let g:CSApprox_eterm = 1
color molokai

" Show (partial) command in the status line
set showcmd

set noerrorbells
set visualbell
set t_vb=

" Use modeline overrides
set modeline
set modelines=10

" CTags
map <Leader>rt :!ctags --extra=+f -R *<CR><CR>
map <C-\> :tnext<CR>

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

" make uses real tabs
autocmd FileType make setlocal noexpandtab

au BufNewFile,BufRead {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru,*.god} set ft=ruby
au BufNewFile,BufRead *.json set ft=javascript
au BufNewFile,BufRead *.hamlbars set ft=haml
au BufNewFile,BufRead *.hamlc set ft=haml
au BufNewFile,BufRead *.jst.ejs set ft=jst

au FileType * set softtabstop=2 tabstop=2 shiftwidth=2

" make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
au FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

autocmd FileType cs setlocal softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

autocmd FileType markdown setlocal spell spelllang=en_us textwidth=79 colorcolumn=80

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Remove trailing whitespace automagically
autocmd BufWritePre *.rb,*.coffee :%s/\s\+$//e

" Inserts the path of the currently edited file into a command
" Command mode: %%
cmap %% <C-R>=expand("%:p:h") . "/" <CR>

" MacVIM shift+arrow-keys behavior (required in .vimrc)
let macvim_hig_shift_movement = 1

"map quick quit
map <leader>qq :qa!<cr>

" JSON formatting
function! FormatJSON()
  :%!python -m json.tool
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" key mapping for window navigation
"
" If you're in tmux it'll keep going to tmux splits if you hit the end of
" your vim splits.
"
" For the tmux side see:
" https://github.com/aaronjensen/dotfiles/blob/e9c3551b40c43264ac2cd21d577f948192a46aea/tmux.conf#L96-L102
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists('$TMUX')
  function! TmuxOrSplitSwitch(wincmd, tmuxdir)
    let previous_winnr = winnr()
    silent! execute "wincmd " . a:wincmd
    if previous_winnr == winnr()
      call system("tmux select-pane -" . a:tmuxdir)
      redraw!
    endif
  endfunction

  let previous_title = substitute(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
  let &t_ti = "\<Esc>]2;vim\<Esc>\\" . &t_ti
  let &t_te = "\<Esc>]2;". previous_title . "\<Esc>\\" . &t_te

  nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
  nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
  nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
  nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
else
  map <C-h> <C-w>h
  map <C-j> <C-w>j
  map <C-k> <C-w>k
  map <C-l> <C-w>l
endif

" Open splits below and right by default
set splitbelow
set splitright

" Make the current directory
nmap <leader>md :silent !mkdir -p %:h<CR>:redraw!<CR>

" Show 2 lines of context
set scrolloff=2

" Make the window we're on as big as it makes sense to make it
set winwidth=84

" We have to have a winheight bigger than we want to set winminheight. But if
" we set winheight to be huge before winminheight, the winminheight set will
" fail.
set winheight=5
set winminheight=5
set winheight=999

" don't delay when you hit esc in terminal vim, this may make arrow keys not
" work well when ssh'd in
set ttimeoutlen=5

function! SaveIfModified()
  if &modified
    :w
  endif
endfunction

"key mapping for error navigation
nmap <leader>[ :call SaveIfModified()<CR>:cprev<CR>
nmap <leader>] :call SaveIfModified()<CR>:cnext<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Much stuff stolen from Gary Bernhardt:
" https://github.com/garybernhardt/dotfiles/blob/master/.vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PROMOTE VARIABLE TO RSPEC LET
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
:map <leader>l :PromoteToLet<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ARROW KEYS ARE UNACCEPTABLE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Left> :echo "no!"<cr>
map <Right> :echo "no!"<cr>
map <Up> :echo "no!"<cr>
map <Down> :echo "no!"<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tmux stuff
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('mouse')
  set mouse=a
  if &term =~ "xterm" || &term =~ "screen"
    " for some reason, doing this directly with 'set ttymouse=xterm2'
    " doesn't work -- 'set ttymouse?' returns xterm2 but the mouse
    " makes tmux enter copy mode instead of selecting or scrolling
    " inside Vim -- but luckily, setting it up from within autocmds
    " works
    autocmd VimEnter * set ttymouse=xterm2
    autocmd FocusGained * set ttymouse=xterm2
    autocmd BufEnter * set ttymouse=xterm2
  endif
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Preview window size hack
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! ResizePreviewWindow()
  if &previewwindow
    set winheight=999
  endif
endfunction
au WinEnter * call ResizePreviewWindow()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Copy paste system clipboard
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>y "*y
map <leader>p "*p
map <leader>P "*P

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Quit help easily
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! QuitWithQ()
  if &buftype == 'help'
    nnoremap <buffer> <silent> q :q<cr>
  endif
endfunction
autocmd FileType help exe QuitWithQ()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This enables iterm cursor changes from vim. In .tmux.conf you'll need:
" set-option -g terminal-overrides '*88col*:colors=88,*256col*:colors=256,xterm*:XT:Ms=\E]52;%p1%s;%p2%s\007:Cc=\E]12;%p1%s\007:Cr=\E]112\007:Cs=\E]50;CursorShape=%?%p1%{3}%<%t%{0}%e%p1%{2}%-%;%d\007'
"
" Source: https://github.com/Casecommons/casecommons_workstation/blob/master/templates/default/dot_tmux.conf.erb
"         https://github.com/Casecommons/vim-config/blob/master/init/tmux.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists('$ITERM_PROFILE')
  if exists('$TMUX')
    let &t_SI = "\<Esc>[3 q"
    let &t_EI = "\<Esc>[0 q"
  else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  endif
end

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This fixes pasting from iterm (and some other terminals, but you'll need to
" adjust the condition) by using "bracketed paste mode"
" I modified it to wait for esc (by using f28/f29)
"
" See: http://stackoverflow.com/questions/5585129/pasting-code-into-terminal-window-into-vim-on-mac-os-x
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists('$ITERM_PROFILE') || exists('$TMUX')
  let &t_ti = "\<Esc>[?2004h" . &t_ti
  let &t_te = "\<Esc>[?2004l" . &t_te

  function! XTermPasteBegin(ret)
    set pastetoggle=<Esc>[201~
    set paste
    return a:ret
  endfunction

  execute "set <f28>=\<Esc>[200~"
  execute "set <f29>=\<Esc>[201~"
  map <expr> <f28> XTermPasteBegin("i")
  imap <expr> <f28> XTermPasteBegin("")
  vmap <expr> <f28> XTermPasteBegin("c")
  cmap <f28> <nop>
  cmap <f29> <nop>
end

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Create any parent directories when writing file
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function s:MkNonExDir(file, buf)
  if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
    let dir=fnamemodify(a:file, ':h')
    if !isdirectory(dir)
      call mkdir(dir, 'p')
    endif
  endif
endfunction
augroup BWCCreateDir
  autocmd!
  autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Persistent undo
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set undofile
set undodir=$HOME/.vim/undo

set undolevels=1000
set undoreload=10000

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LAST SECTION
" Include user's local vim config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

