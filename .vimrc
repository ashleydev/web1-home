hi StatusLine   term=bold cterm=bold ctermfg=Yellow ctermbg=Blue          gui=bold guifg=#FFFFFF guibg=#0050EE

color blue

set visualbell t_vb=

filetype plugin on " needed for NERDcommenter
filetype indent on
"------------------------------------------------------------

syntax enable

set laststatus=2 " takes up a line to show various status facts

" UTF-8
set nocompatible
set encoding=utf-8
set fileencodings=ucs-bom,utf-8
map \u :set fileencoding=latin1<CR>:w<CR>
map \U :set fileencoding=utf-8<CR>:w<CR>

" Tab options that Eric setup for me
set tabstop=8
set sw=2
set softtabstop=2

" highlight search
set hls 

" line numbers
set nu
map <C-n> :set nu!<CR>

" Annoyance prevention
map w: :w
map :W :w
map :w1 :w!
map :w:q :wq
map :w:w :w
map :w\ :w
map :qw :wq
map :Q :q
map :q1 :q!
" vim grep annoyance prevention
map :G :g 

" Clear highlighted search text
map - :nohlsearch<Cr>

" quick finds
map ,s /sjohnson<CR>
map ,f /fixme<CR>

" Moves a line to the very top of the file
map \- kmtjdd1GP`t

" Destroy highlighted parens... proven somewhat useful.  not perfect
map ,p mp%x`px

" Case Insensitive search
set ignorecase
set smartcase

" Code testers.
function CodeTest (syn)
  if a:syn == "php"
    w! /tmp/tmpfs/xphptest-sj.php
    !php -l /tmp/tmpfs/xphptest-sj.php
  elseif a:syn == "perl"
    w! /tmp/tmpfs/xpl-sj.pl
    "!perl -c /tmp/xpl-sj.pl
    !perl -I/home/pubstock/perl/lib -I/home/http/www/admin -c /tmp/tmpfs/xpl-sj.pl
  endif
endfunction

" Code test!
map \t :!clear<Cr><Cr>:call CodeTest(b:current_syntax)<CR>

" javascript code packer
map \j :!unpackem.pl %<CR>
map \J :!packem.pl % !<CR>

" show absolute path of current file in vi on bottom of screen
map ,a :let absolutepath=expand("%:p")<CR>:echo absolutepath<CR>

" Exchange two characters without remembering which comes first.  Will soon become obselete.
map ,x xph

" Delete from the bottom down
map ,. :.,$d<Cr>

" up and down behaviour improved
map j gj
map k gk
map OA k
map OB j

" Add a simple PHP logger
map \z oLogger::log(print_r($<Esc>mta,1), "/tmp/mikey-log");<Esc>`ta

" Makes it so * only highlights a searchterm instead of going to the next one
map * *N

" for Perl: adds a SHIFT-I + my before a var
map \m mt^imy <Esc>`t3l

" HTML macros
map \p mtI<p><Esc>A</p><Esc>`t

" for the ~/bin/hlp engine : fixme make it somehow only work if editing this
" help function
map \] I].b("<Esc>A").q[<Esc>
map ] G?$database{'   '}<CR>-11lcw

" auto { } intenders " fixme make the \S do the opposite
map \s mtjVk$h%k>`t
map \S mtkVj%j>`t

" ~/bin/mir on the current file
map \M :!mir %:p<CR>

" handy indenter (relies on bottom line code. for use when lines get out of
" whack due to auto-intent being accidently turned off, etc
map \i mtj^hv<Home>ykP`t

" quick exit / save commands
map  :w!<CR>:q!<CR>
imap  <Esc>:w!<CR>:q!<CR>
imap <C-x> <Esc>:qa!<CR>

" get me outta here shortcuts
map q :qa<CR>
map <C-x> :qa!<CR>

" perl macros
map \c mtosub trim { my $str = shift; $str =~ s/^\s*//; $str =~ s/\s*$//; return $str; }<Esc>`tjj
map \v mtouse v5.10.0;<Esc>`tjj

" NERDcommenter additions and via my classic macros
map z ,cc
map Z ,cu
map \d ,cA sjohnson (<Esc>:r! date +\%d\%b\%Y \| tr 'A-Z' 'a-z' <CR>kJhxA):<Space>
" fixme - get ,cI to work
map \D O<Esc>,cA sjohnson (<Esc>:r! date +\%d\%b\%Y \| tr 'A-Z' 'a-z' <CR>kJhxA):<Space>

" Disable arrow keys in vim to force a habit.  Turns out I like to use both!
"noremap  <Up> ""
"noremap! <Up> <Esc>
"noremap  <Down> ""
"noremap! <Down> <Esc>
"noremap  <Left> ""
"noremap! <Left> <Esc>
"noremap  <Right> ""
"noremap! <Right> <Esc>

" F5 key date writer, similar to notepad
map [15~ :r! date<CR>kJ$
