# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias vless='vim -u /usr/share/vim/vim73/macros/less.vim'
alias hn='w3m news.ycombinator.com'

function google() { w3m https://google.ca/search?q=$(echo "$@" | sed "s/ /+/g"); }
function wiki() { w3m https://google.ca/search?q=wiki+$(echo "$@" | sed "s/ /+/g"); }
function jisho() { w3m http://jisho.org/search/$(echo "$@" | sed "s/ /+/g"); }

alias less='less -R'
alias s='git status'
alias d='git diff'
alias c='git diff --cached'
alias show='git show'
function dog() { pygmentize -P tabsize=4 "$@" | less -R;}
function grepl() { grep -Rnsi --color=always "$@";}
function spell() { echo "$@" | aspell -a | tail -n+2; }
