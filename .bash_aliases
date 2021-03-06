# common aliases

# EXPORTS
export EDITOR='/home/sjohnson/vi_perl_starter.sh'

[ -f ~/.bash_aliases.colourprompt ] && . ~/.bash_aliases.colourprompt
[ -f ~/.bash_functions ] && . ~/.bash_functions

if [ "$HOSTNAME" = "web1" ] ; then
  [ -f ~/.bash_aliases.tbm ] && . ~/.bash_aliases.tbm
  [ -f ~/.bash_aliases.web1 ] && . ~/.bash_aliases.web1
elif [ "$HOSTNAME" = "web2" ] ; then
  [ -f ~/.bash_aliases.tbm ] && . ~/.bash_aliases.tbm
  [ -f ~/.bash_aliases.web2 ] && . ~/.bash_aliases.web2
fi

# ssh agent mode
alias isagent='if [ "$SSH_AGENT_PID" ] ; then echo Agent is set ; else echo No ; fi'
alias isa='isagent'

if [ "$SSH_AGENT_PID" ] ; then
  PS1=[${BRIGHT_GREEN}AGENT${RESET}]\ "$PS1"
fi

alias errlev='echo $?'

# DOS / microsoft command land
alias ren='mv'
alias copy='cp'
alias cls='clear'
alias tree='find -type d'
alias dirb='find $PWD'
alias del='rm'
alias erase='rm'
alias notepad='vi'

# GNU screen
alias sca='screen -U'
alias scr='screen -r || screen -U'

# better default actions
alias su='sudo -s'
alias less='less -i -R'
alias lynx='lynx -nopause -accept_all_cookies'
alias w='w -s | ~/bin/hl sjohnson | ~/bin/hl falzer --color=blue --bold | ~/bin/hl rfb --color=green'
alias which='. ~/bin/which_helper_partA.sh'
alias du='du -h'
alias df='df -h'
alias cg="sudo perl ~sjohnson/bin-tbm/crongrep"

# vi harmony
alias vim='vi'
alias vi="$EDITOR"

# ls harmony
alias lsl='ls -l --color=always | grep --color=never ^l'
#alias falz="ls -l | grep --color=always falzer"
alias l='ls -lth'

# grep harmony
alias gr='grep -risn'
alias g='grep -sin'

# mv harmony
alias mvsafe='mv --interactive'

# argh!!! stoppers
alias gvin='gvim'
alias ji='vi'
alias type='cat'
alias iv='vi'
alias lcd='cd'
alias gerp='grep'
alias greo='grep'
alias greb='grep'
alias cd..='cd ..'
alias cd-='cd - > /dev/null'
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
alias whcih='which'
alias it='git'

# .bashrc helper
alias bf='. ~/.bash_functions'
alias reb='unalias -a && . ~/.bashrc'
alias .b='$EDITOR ~/.bashrc'
alias .bf='$EDITOR ~/.bash_functions'
alias ,b='.b'
alias .ba='$EDITOR ~/.bash_aliases'
alias ,ba='.ba'

# tmp directory helper
alias tmp="cd /tmp"

# perl helper
alias ph='perldoc -f'

# home directory tools
alias .v='$EDITOR ~/.vimrc'
alias .s='$EDITOR ~/.screenrc'
alias .i='$EDITOR ~/.inputrc'
alias .p='$EDITOR ~/.profile'
alias bin='cd ~/bin'

# git shortcuts
alias gb='git branch'
alias gs='git status'
alias gd="git diff"
alias ga="git add"
alias gchk='git checkout'
alias gcheck='gchk'
alias gwc='git whatchanged'
alias gl='git log'
alias gc='git commit'
alias gpom='git push origin master'

# shortcuts
alias mine="ls -l | grep --colour=never $USER"
