# NOTE:  this file is more than just "bash aliases"... it is also some common commands
# that i didn't want to include into .bashrc as .bashrc changes upon Ubuntu upgrades,
# and on other *nix systems.

# path setup
if [ "$HOSTNAME" = "web1" ] || [ "$HOSTNAME" = "web2" ] ; then

  if [ ! "$EXTRA_PATHS_SET" ] ; then
    
    export EXTRA_PATHS_SET=1

    if [ -d /home/pubstock/perl ] ; then
	PATH=/home/pubstock/perl:$PATH
    fi

    if [ -d ~/bin-tbm ] ; then
	PATH=$PATH:~/bin-tbm
    fi

    if [ -s ~/.newsfeed ] ; then
      echo "^[[1;33mNEWSFEED:^[[00m"
      cat ~/.newsfeed
      echo
    fi

  fi

fi

# prompt color vars
DULL=0
BRIGHT=1

FG_BLACK=30
FG_RED=31
FG_GREEN=32
FG_YELLOW=33
FG_BLUE=34
FG_VIOLET=35
FG_CYAN=36
FG_WHITE=37

FG_NULL=00

BG_BLACK=40
BG_RED=41
BG_GREEN=42
BG_YELLOW=43
BG_BLUE=44
BG_VIOLET=45
BG_CYAN=46
BG_WHITE=47

BG_NULL=00

##
# ANSI Escape Commands
##
ESC="\033"
NORMAL="\[$ESC[m\]"
RESET="\[$ESC[${DULL};${FG_WHITE};${BG_NULL}m\]"

##
# Shortcuts for Colored Text ( Bright and FG Only )
##

# DULL TEXT

BLACK="\[$ESC[${DULL};${FG_BLACK}m\]"
RED="\[$ESC[${DULL};${FG_RED}m\]"
GREEN="\[$ESC[${DULL};${FG_GREEN}m\]"
YELLOW="\[$ESC[${DULL};${FG_YELLOW}m\]"
BLUE="\[$ESC[${DULL};${FG_BLUE}m\]"
VIOLET="\[$ESC[${DULL};${FG_VIOLET}m\]"
CYAN="\[$ESC[${DULL};${FG_CYAN}m\]"
WHITE="\[$ESC[${DULL};${FG_WHITE}m\]"

# BRIGHT TEXT
BRIGHT_BLACK="\[$ESC[${BRIGHT};${FG_BLACK}m\]"
BRIGHT_RED="\[$ESC[${BRIGHT};${FG_RED}m\]"
BRIGHT_GREEN="\[$ESC[${BRIGHT};${FG_GREEN}m\]"
BRIGHT_YELLOW="\[$ESC[${BRIGHT};${FG_YELLOW}m\]"
BRIGHT_BLUE="\[$ESC[${BRIGHT};${FG_BLUE}m\]"
BRIGHT_VIOLET="\[$ESC[${BRIGHT};${FG_VIOLET}m\]"
BRIGHT_CYAN="\[$ESC[${BRIGHT};${FG_CYAN}m\]"
BRIGHT_WHITE="\[$ESC[${BRIGHT};${FG_WHITE}m\]"

# REV TEXT as an example
REV_CYAN="\[$ESC[${DULL};${BG_WHITE};${BG_CYAN}m\]"
REV_RED="\[$ESC[${DULL};${FG_YELLOW}; ${BG_RED}m\]"

PROMPT_COMMAND='export ERR=$?'

cdc () {
  if [ -n "$1" ] ; then
    [ -f "$1" ] && cd `echo $1 | sed -e 's/\/[^\/]*$//'` && return
    [ -d "$1" ] && cd "$1" && return
    echo "$0: cd: $1: No such file or directory" && return
  else
    cd && return
  fi
}

alias cd=cdc

# color prompt changes
if [ "$HOSTNAME" = "web2" ] ; then
  PS1="${BRIGHT_RED}\u${BRIGHT_YELLOW}@${BRIGHT_RED}\h${WHITE}:\w${BRIGHT_CYAN}${NORMAL}\$ ${RESET}"
elif [ "$HOSTNAME" = "mooseman" ] ; then
  PS1="${BRIGHT_VIOLET}\u${BRIGHT_YELLOW}@${BRIGHT_VIOLET}\h${WHITE}:\w${BRIGHT_CYAN}${NORMAL}\$ ${RESET}"
fi

if [ "$USER" = "root" ] ; then
  PS1="${BRIGHT_CYAN}\u${NORMAL}@\h:\w\$ ${RESET}"
fi

if [ "$SSH_AGENT_PID" ] ; then
  PS1=[${BRIGHT_GREEN}AGENT${RESET}]\ "$PS1"
fi

# EXPORTS
export EDITOR=vi

# even after the nov 2009 ubuntu upgrade, you still need to run BOTH of these commands in this order to enable the behaviour you want
export TERM=linux
export TERM=xterm

#### ACTUAL ALIASES START HERE ####
#
# grep helper
alias gerp='grep'
alias greo='grep'
alias greb='grep'

# microsoft command land
alias ren='mv'
alias copy='cp'
alias cls='clear'
alias tree='find -type d'
alias dirb='find $PWD'
alias del='rm'

# better default actions
alias su='sudo -s'
alias less='less -i -R'
alias lynx='lynx -nopause -accept_all_cookies'
alias w='w -s | ~/bin/hl sjohnson | ~/bin/hl falzer --color=blue --bold | ~/bin/hl rfb --color=green'
alias which='. /home/sjohnson/bin/which_helper_partA.sh'
alias du='du -h'
alias df='df -h'
alias cg="sudo perl ~sjohnson/bin-tbm/crongrep"

# vi harmony
alias vi='vim'

# ls harmony
alias lsl='ls -l --color=always | grep --color=never ^l'
#alias falz="ls -l | grep --color=always falzer"
alias l='ls -lth'

# grep harmony
alias gr='grep -risn'
alias g='grep -i'

# mv harmony
alias mvsafe='mv --interactive'

# argh!!! stoppers
alias gvim='vi'
alias nv='mv'
alias vuin='vi'
alias lks='ls'
alias los='ls'
alias qvi='vi'
alias viun='vin'
alias 1ls='ls'
alias vf='cd'
alias s='ls'
alias rn='rm'
alias ccd='cd'
alias v='vi'
alias 'ls-l'='ls -l'
alias LS='ls'
alias 'ls-'='ls --hyphen_first_arg'
alias sl='ls'
alias arky='awky'
alias bim='bin'
alias ci='vi'
alias in='bin'
alias vis='vi'
alias mt='cmt'
alias vvi='vi'
alias hh='h'
alias eb='reb'
alias lls='ls'
alias evl='devl'
alias fvi='cfvi'
alias bi='vi'
alias d='cd'
alias liog='log'
alias les='less'
alias pign='ping'
alias clvi='cfvi'
alias og='log'
alias alais='alias'
alias vio="vi"
alias voi="vi"
alias viu="vi"
alias vui="vi"
alias vivi="vi"
alias ks="ls"
alias alais='alias'
alias mdkir='mkdir'
alias alis='alias'
alias wc-l='wc -l'
alias cfv='cfvi'

# .bashrc helper
alias reb='unalias -a && . ~/.bashrc'
alias .b='vi ~/.bashrc'
alias ,b='.b'
alias .ba='vi ~/.bash_aliases'
alias ,ba='.ba'

# tmp directory helper
alias tmp="cd /tmp"
alias tj="cd /tmp/sjohnson"

# perl helper
alias ph='perldoc -f'

# common site edit places
alias I='videv /home/http/www/stsite.php'
alias c='videv /home/http/www/js/_css.php'
alias i='videv /home/http/www/index.php'
alias j='videv /home/http/www/stmain.js'
alias bc='videv /home/http/code/site/BaseClass.php'
alias pc='videv /home/http/code/site/PermissionCheck.php'
alias loginbox='videv /home/http/template/default/header3.tpl'
alias footer='videv /home/http/template/default/footer.tpl'
alias gen="videv /home/pubstock/perl/lib/Pubstock/General.pm"
alias o2="videv /home/pubstock/perl/lib/Pubstock/Combo/ONIXXML2.pm"
alias ox='videv /home/pubstock/perl/lib/Pubstock/Combo/ONIXXML_extra.pm'
alias ts='videv /home/http/code/ts_functions.php'
alias gamut='videv /home/http/code/site/SiteAction/SA_TLViewer2.php'
alias gamutj='videv /home/http/template/default/h/tlviewer2.tpl'
alias tl9='videv /home/http/code/site/SiteAction/SA_TitleEdit2009.php'
alias tl9j='videv /home/http/javascript/titleedit2009.js'
alias tl9js='tl9j'
alias tl9h='tl9j'

# quick log edits
alias m="tail -f /tmp/mikey-log"
alias mlog='m'
alias mvi="vi /tmp/mikey-log"
alias dolog='/home/http/dolog.sh'
alias plog='vi /home/http/log/phperror.log'
alias flog='tail -f /home/http/code/flex/log/activity.log'

# useful commands
alias doquery='sudo -u www-data php /home/http/code/test/doquery.php'
#alias esdr='exec screen -d -r'
alias cf='/home/http/codefind.sh'

# search frontends
alias saf='/home/http/saf.sh' # not sure what this does
alias sf='/home/http/site_find.pl'
alias sfi='/home/http/site_find.pl --case-insensitive'
alias ff='/home/http/ffind.sh' # not sure what this does

# Change directories (http tree) - now with dev tree env var changing!
alias img=". /home/sjohnson/bin-tbm/cddev /home/http/www/i"
alias ~h=". /home/sjohnson/bin-tbm/cddev /home/http"
alias sa=". /home/sjohnson/bin-tbm/cddev /home/http/code/site/SiteAction/"
alias web=". /home/sjohnson/bin-tbm/cddev /home/http/www"
alias adm=". /home/sjohnson/bin-tbm/cddev /home/http/www/admin"
alias jsp='. /home/sjohnson/bin-tbm/cddev /home/http/www/js'
alias js='. /home/sjohnson/bin-tbm/cddev /home/http/javascript'
alias tmpimg='. /home/sjohnson/bin-tbm/cddev /home/http/www/tmpimg'
alias dbo='. /home/sjohnson/bin-tbm/cddev /home/http/code/site/DBO'
alias list='. /home/sjohnson/bin-tbm/cddev /home/http/code/site/ListFactory'

# Change directories
alias tmpfs='cd /tmp/tmpfs'
alias tpl='h'
alias cd-='cd - > /dev/null'
alias cliftp='cd /var/ftp/client/1677004'
alias P='cd ~pubstock/perl'
alias SA="sa"
alias plib="cd /home/pubstock/perl/lib/Pubstock"
alias int="cd /home/pubstock/interm"
alias pw="cd ~/perl"
alias slib="cd /usr/local/lib/site_perl/Sjohnson"

# needed to dot execute these
alias dev=". ~/bin-tbm/dev"
alias h='. ~/bin-tbm/h'

# Remote access
alias db="ssh `/home/sjohnson/bin-tbm/getcfgbykey db_host`" # main database
alias db2="ssh `/home/sjohnson/bin-tbm/getcfgbykey db_host_backup`" # backup database

#alias loga="sudo -u root tail /var/log/apache2/error.log"

# "farm" programming
alias vif="vi /tmp/tmpfs/farm.pl"
alias fa="perl /tmp/tmpfs/farm.pl"
alias vip='vi /tmp/tmpfs/tester.php'
alias pt='php /tmp/tmpfs/tester.php'

# boss key paste bin
alias cmt="vi /home/sjohnson/doc/cmt.php"

# home directory tools
alias .v='vi ~/.vimrc'
alias .i='vi ~/.inputrc'
alias .p='vi ~/.profile'
alias bin='cd ~/bin'
alias rmnews="[ -e ~/.newsfeed ] && rm ~/.newsfeed"
alias doc="cd ~/doc"
alias owe="vi /home/sjohnson/ot/owe.txt"
alias ot="cd ~/ot"
alias vipass='vi ~/doc/pass'
alias pass='cat ~/doc/pass'
alias phead='pass | head'
alias ptail='pass | tail'
alias poass='pass'
alias adr="vi /home/sjohnson/doc/mailingaddresses.txt"

# command shortcuts
alias cronlist='sudo /home/pubstock/perl/cronlist.pl --active-only --no-blanklines'
alias cd..='cd ..'
alias md5='md5sum'
alias perli='perl -I/home/pubstock/perl/lib'
alias mc='masscommit'
alias ms='mass_substitution.pl'
alias t='today'
alias blank='clear ; cat'

# quick tests
alias testclient='ftp client.bookmanager.com'
alias moldy='support_expiry_report.pl mail@bookmanager.com xmlisbn_countdown services'

# ssh agent mode
alias agent="ssh-agent sh -c 'ssh-add && ssh-add /home/sjohnson/.ssh/github && bash'"
alias isagent='if [ "$SSH_AGENT_PID" ] ; then  echo Agent is set ; else  echo No ; fi'
alias isa='isagent'

# _fvi helper
alias Ss='~/bin-tbm/repo_sfvi ~'
alias Hs='~/bin-tbm/repo_sfvi /home/http'
alias hs='Hs'
alias Ps='~/bin-tbm/repo_sfvi /home/pubstock/perl'
alias Ds='~/bin-tbm/repo_sfvi /home/sjohnson/http'
alias ds=Ds

### web1 ###
if [ $HOSTNAME = web1 ] ; then
  alias w1mir='isweb1 && mir'
  alias web2="ssh `/home/sjohnson/bin-tbm/getcfgbykey ip_web2`"
  alias dev2="web2"

  # sjohnson (11jan2010): used for a new system which keeps an env var if i want all my aliases to work as dev mode files

    # toggle
    alias dev-='if [ "$DEVMODE" = 1 ] ; then unset DEVMODE && echo DEVMODE now off ; else export DEVMODE=1 && echo DEVMODE now on ; fi'

    # force on
    alias dev1='export DEVMODE=1 && echo DEVMODE now on'

    # force off
    alias dev0='unset DEVMODE && echo DEVMODE now off'

    # check
    alias dev?='if [ "$DEVMODE" = 1 ] ; then echo on ; else echo off ; fi'

  # these are so that I don't put something in for these text files on web2 and have it wiped the next day
  alias 3="vi ~/.3rdparty"
  alias vihlp='vi ~sjohnson/bin-tbm/hlp'
  alias ord='vi ~/doc/order.txt'
  alias inv="vi ~/doc/invoice.txt"
  alias r1='[ -d ~/rtk ] && cd ~/rtk ; vi ~/rtk/rtk.txt'
  alias todo='vi /home/sjohnson/doc/clean.up.my.life'

  # web2 backup steps to be ran only on web1
  alias p1='sudo ./projectlist_grpadm.sh'
  alias p2='./projectlist_git.sh'
  alias p3='./projectlist_diff.sh'
  alias p4='./projectlist_jspack.sh'
  alias p2mc='[ -f "/tmp/sjohnson/p2.log" ] && [ -r "/tmp/sjohnson/p2.log" ] && masscommit `cat /tmp/sjohnson/p2.log`'
  alias flmakelive='listinterface --individual-processing makelive'
  alias flneedcommit='listinterface --batch-processing needcommit'
  alias fldiff='listinterface --batch-processing difflive'
  alias flnc='flneedcommit'

fi

# web1 and web2 bk dev shit
alias massdevcp='/home/http/copy_tree_dev.sh ~sjohnson/http'
alias f='11pm-warn.pl && listinterface_git --individual-processing vi'
alias flmir='listinterface --batch-processing mir'
alias flbkdiff='listinterface --batch-processing bkdiff'
alias flsyn='listinterface --batch-processing syntaxtest'
#alias devl='dev 1'
alias n="cat ./notes"
alias vin="vi ./notes"
alias flg='flgrpadm'
alias mnvjs='mvjs'
alias mvjsp='mvjs --pack'
alias lspl='ls -l `cat /tmp/sjohnson/projectlist`'
alias plgrpadm='grpadm `cat /tmp/sjohnson/projectlist`'
alias copyback='perl /home/sjohnson/bin-tbm/copyback.pl'
alias flmd5='md5sum `cat filelist`'
alias pl='cat /tmp/sjohnson/filelist'
alias vipl='vi /tmp/sjohnson/projectlist'
alias backup=". ./backup.sh" # sjohnson (12nov2008): made so that it uses the . instead of running the command
alias plcat='cat /tmp/sjohnson/projectlist'
alias catpl="plcat"
alias vifl='vi ./filelist'
alias cpb='sudo /home/sjohnson/bin-tbm/flgrpadm && copyback ! && mvjs' # the last one is an alias call

# mountain of quick backup edits
alias 1='f 1' ; alias 2='f 2' ; alias 3='f 3' ; alias 4='f 4'
alias 5='f 5' ; alias 6='f 6' ; alias 7='f 7' ; alias 8='f 8'
alias 9='f 9' ; alias 10='f 10' ; alias 11='f 11' ; alias 12='f 12'
alias 13='f 13' ; alias 14='f 14' ; alias 15='f 15' ; alias 16='f 16'
alias 17='f 17' ; alias 18='f 18' ; alias 19='f 19' ; alias 20='f 20'
alias 21='f 21' ; alias 22='f 22' ; alias 23='f 23' ; alias 24='f 24'
alias 25='f 25' ; alias 26='f 26' ; alias 27='f 27' ; alias 28='f 28'
alias 29='f 29' ; alias 30='f 30' ; alias 31='f 31' ; alias 32='f 32'
alias 33='f 33' ; alias 34='f 34' ; alias 35='f 35' ; alias 36='f 36'
alias 37='f 37' ; alias 38='f 38' ; alias 39='f 39' ; alias 40='f 40'
alias 41='f 41' ; alias 42='f 42' ; alias 43='f 43' ; alias 44='f 44'
alias 45='f 45' ; alias 46='f 46' ; alias 47='f 47' ; alias 48='f 48'
alias 49='f 49' ; alias 50='f 50' 

### web2 ###
if [ $HOSTNAME = web2 ] ; then
  alias flw1diff='listinterface --batch-processing w1diff'
  alias flw1diffnv='listinterface --batch-processing "w1diff -nv"'
  alias web1="ssh `/home/sjohnson/bin-tbm/getcfgbykey ip_web1`"
fi

# KANJI
alias sug='vi /home/sjohnson/rtk/suggestions.txt'
alias sen='cd ~/rtk/sentences'
alias on='vi /home/sjohnson/rtk/rtk2-on.txt'
alias r2='cd ~/rtk'
alias rh='r2 ; ./rh'
alias p='r2 ; vi prims'
alias gp='r2 ; cat prims | g'

# advaita
alias forty='lynx http://www.satramana.org/html/forty_verses_on_reality.htm' # 40 verses on reality

# non-work related programming projects
alias wb='vi /home/sjohnson/perl/weechat_plugin/wb.pl'

# clipper
alias src='cd /tmp/sjohnson/harbour/src'
alias prg='cd /tmp/sjohnson/prgs'
alias hw="vi hello.c"

# junk
alias mk="./mk"

# git stuff
#alias gsh="(~h ; git status | grep modified | awky 3 | abs | sort | uniq ; cd-)"
#alias gsP="(P ; git status | grep modified | awky 3 | abs | sort | uniq ; cd-)"
#alias gsm="(gsh ; gsP)"
#alias gs="\
alias gs='git status'
alias gd='git diff'
alias gwc='git whatchanged'
#(~h ; git status | hl modified | hl deleted r | hl new.file g ; cd-) | less ;\
#(P ; git status | hl modified | hl deleted r | hl new.file g ; cd-) | less" # brackets for piping
alias W='sudo -u www-data -s'
alias gc='git commit'
alias gch='git checkout'
alias gpom='git push origin master'
alias gpsm='git pull sjohnson master'
alias gpwm='git pull www-data master'
alias devl='dev1 ; ~h'

# test shit
alias mytest='cd /home/sjohnson/http/www/test'
