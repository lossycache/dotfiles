alias g=git
alias gs="git status"
alias gd="git diff"
alias gdb="git branch | fzf -m | xargs -I{} git branch -D {}"
alias gsb="git branch | fzf | xargs -I{} git switch {}"
alias gcb="git rev-parse --abbrev-ref HEAD"

alias d=docker
alias dcmp="docker compose"

alias ls="gls --color -h --group-directories-first"

alias intelbrew="arch -x86_64 brew"
