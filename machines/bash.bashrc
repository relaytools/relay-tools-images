mkdir -p $HOME/.local/bin
export GOBIN=$HOME/.local/bin
export GOPATH=$HOME
export GOROOT=/usr/local/go
export PATH=$GOBIN:/usr/local/go/bin:$GOROOT/bin:$PATH
export GOPROXY=direct
export GOSUMDB=off

alias less='less --RAW-CONTROL-CHARS'
export LS_OPTS='--color=auto'
alias ls='ls ${LS_OPTS}'

PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;37m\]\u@\h\[\033[00m\] \[\033[01;37m\]\w\[\033[00m\] "
export HISTCONTROL="erasedups"
export HISTIGNORE="ls:history"
export HISTSIZE=100000
clear