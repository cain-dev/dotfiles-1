" not compatible with ancient versions
set nocompatible

" use mouse to resize, scroll, etc. even within tmux
set mouse+=a

" recursive within current directory
set path+=**

" enable pathogen
execute pathogen#infect()

" use system clipboard as default
set clipboard=unnamed
if has('unnamedplus')
    set clipboard=unnamed,unnamedplus
endif

" enable syntax
syntax on
colorscheme OceanicNext

" enable auto indent
set autoindent

" expand tabs to 4 spaces
set expandtab
set tabstop=4
" when using << or >> commands, shift lines by 4 spaces
set shiftwidth=4

set relativenumber              " show line numbers
set number
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
set cursorcolumn        " highlight current column
hi CursorLine cterm=NONE
filetype indent on      " load filetype-specific indent files
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to
set showmatch           " show parenthesis matching
set incsearch           " search as characters are entered
set hlsearch            " highlight matches

set spell spelllang=en_us

" disable omnicompletion
filetype plugin on

" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>

" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

" GLSL syntax
autocmd! BufNewFile,BufRead *.vs,*.fs set ft=glsl
" EuroVis template has .inc latex files
autocmd! BufNewFile,BufRead *.inc set syntax=tex

" map ctr-movement to move across splits
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" open splits to right and bottom
set splitbelow
set splitright

" map space to insert a single character and return to normal mode
nnoremap <Space> i_<Esc>r

" double space saves buffer
nnoremap <space><space> :w<cr>

" search for selected text
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" csyntaxafter
autocmd! FileType c,cpp,java,php call CSyntaxAfter() 

" prompt for reload when file changes
:au WinEnter * checktime

" Ctrl-P config
set wildignore+=*.class,*.a,*.o
set wildignore+=*.out,*.dvi
set wildignore+=.DS_Store,.git,.hg,.svn
set wildignore+=*~,*.swp,*.tmp
set wildignore+=*/releases/**
" Ctrl-P open in new tab by default, <C-t> opens in current tab
let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<c-t>'],
    \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
    \ }
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
" Ctrl-P working directory
let g:ctrlp_working_path_mode = 'rc'
" Ignore files
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.dll
" Custom file listing command
let g:ctrlp_user_command = 'find %s -type f'
" Ignore files in .gitignore
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" center view on the search result
noremap n nzz
noremap N Nzz

" show tab numbers
set tabline=%!MyTabLine()  " custom tab pages line
function MyTabLine()
        let s = '' " complete tabline goes here
        " loop through each tab page
        for t in range(tabpagenr('$'))
                " set highlight
                if t + 1 == tabpagenr()
                        let s .= '%#TabLineSel#'
                else
                        let s .= '%#TabLine#'
                endif
                " set the tab page number (for mouse clicks)
                let s .= '%' . (t + 1) . 'T'
                let s .= ' '
                " set page number string
                let s .= t + 1 . ' '
                " get buffer names and statuses
                let n = ''      "temp string for buffer names while we loop and check buftype
                let m = 0       " &modified counter
                let bc = len(tabpagebuflist(t + 1))     "counter to avoid last ' '
                " loop through each buffer in a tab
                for b in tabpagebuflist(t + 1)
                        " buffer types: quickfix gets a [Q], help gets [H]{base fname}
                        " others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname
                        if getbufvar( b, "&buftype" ) == 'help'
                                let n .= '[H]' . fnamemodify( bufname(b), ':t:s/.txt$//' )
                        elseif getbufvar( b, "&buftype" ) == 'quickfix'
                                let n .= '[Q]'
                        else
                                let n .= pathshorten(bufname(b))
                        endif
                        " check and ++ tab's &modified count
                        if getbufvar( b, "&modified" )
                                let m += 1
                        endif
                        " no final ' ' added...formatting looks better done later
                        if bc > 1
                                let n .= ' '
                        endif
                        let bc -= 1
                endfor
                " add modified label [n+] where n pages in tab are modified
                if m > 0
                        let s .= '[' . m . '+]'
                endif
                " select the highlighting for the buffer names
                " my default highlighting only underlines the active tab
                " buffer names.
                if t + 1 == tabpagenr()
                        let s .= '%#TabLineSel#'
                else
                        let s .= '%#TabLine#'
                endif
                " add buffer names
                if n == ''
                        let s.= '[New]'
                else
                        let s .= n
                endif
                " switch to no underlining and add final space to buffer list
                let s .= ' '
        endfor
        " after the last tab fill with TabLineFill and reset tab page nr
        let s .= '%#TabLineFill#%T'
        " right-align the label to close the current tab page
        if tabpagenr('$') > 1
                let s .= '%=%#TabLineFill#%999Xclose'
        endif
        return s
endfunction


"
" NetRW configuration
"
" map ctrl-t to NetRW
map <C-t> :Vexplore<CR>

" Width
let g:netrw_winsize = 25
" Tree-like style
let g:netrw_liststyle = 3
" Remove dir banner
let g:netrw_banner = 0
" Open files in new vertical split
let g:netrw_browse_split = 4
let g:netrw_altv = 1
" remap control-enter to open files in new tab
nmap <silent> <C-CR> t :rightbelow 20vs<CR>:e .<CR>:wincmd h<CR>
