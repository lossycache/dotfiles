# +##########
# .zshrc used for setting up interactive sessions only
##########

# set up completions
autoload -U compinit; compinit

# kitty options
# disabled the automatic shell integration and sets it up manually, so that kitty config is applied in sub-shells
# See https://sw.kovidgoyal.net/kitty/shell-integration/#manual-shell-integration
if test -n "$KITTY_INSTALLATION_DIR"; then
  export KITTY_SHELL_INTEGRATION="enabled"
  autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
  kitty-integration
  unfunction kitty-integration
fi

# append new entries to history file as soon as they're entered
setopt inc_append_history
export HISTSIZE=10000
export SAVEHIST=10000

# fzf options
export FZF_DEFAULT_COMMAND='rg --hidden -l ""'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse'

export EDITOR=nvim
# vim-mode
bindkey -v

# restore ctrl-r for history-search behavior
bindkey ^R history-incremental-search-backward 

# restore delete key behavior
bindkey "^?" backward-delete-char

# source aliases
source "${ZDOTDIR}/aliases.zsh"

# load functions
fpath=("${ZDOTDIR}/zsh_functions" "${fpath[@]}");
# autoload all files in that directory so they are available to use.
# unfunction all functions first, since autoload doesn't "reload"
for f in $fpath[1]/*(.:t); do
  unfunction "${f}" 2>/dev/null
done
autoload -U $fpath[1]/*(.:t)

# set prompt
# `setopt prompt_subst` enables parameter expansion, command substitution, and arithmetic expansion in the prompt string.
# This means that any shell commands or variables included in the prompt string will be evaluated and expanded when the prompt is displayed,
# rather than when the prompt is set.
# Single quotes are needed to ensure that the prompt isn't evaluted when it's set.
setopt prompt_subst 
NEWLINE=$'\n'
PROMPT='%(?..%F{red}⏺ )%B%F{cyan}%~%F{reset_color}%b$(print_git_branch)%F{yellow}$(is_git_dirty)%F{reset_color}${NEWLINE}> '

# !! should not execute the last command, only print it to the edit buffer
setopt hist_verify

# source fzf options
source $ZDOTDIR/.fzf.zsh

# set psql password file location
export PGPASSFILE="${XDG_CONFIG_HOME}/.pgpass"

# export GOROOT
export GOROOT=$(go env GOROOT)

# zsh autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^A' autosuggest-accept # accept the whole line
bindkey '^W' forward-word # accept the current word
