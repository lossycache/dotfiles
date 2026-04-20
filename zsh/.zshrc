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

export PKG_CONFIG_PATH="$(brew --prefix)/opt/openssl/lib/pkgconfig:$PKG_CONFIG_PATH"
export PKG_CONFIG_PATH="$(brew --prefix)/lib/pkgconfig:$PKG_CONFIG_PATH"
export CPATH="$(brew --prefix)/include:$CPATH"
export LIBRARY_PATH="$(brew --prefix)/lib:$LIBRARY_PATH"

# Gitlab token
export GITLAB_TOKEN=$(security find-generic-password -a ${USER} -s gitlab_token -w)

# BEGIN ANSIBLE MANAGED BLOCK
# Load homebrew shell variables
eval "$(/opt/homebrew/bin/brew shellenv)"

# Force certain more-secure behaviours from homebrew
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CASK_OPTS=--require-sha
export HOMEBREW_DIR=/opt/homebrew
export HOMEBREW_BIN=/opt/homebrew/bin

# Load python shims
eval "$(pyenv init -)"

# Load ruby shims
eval "$(rbenv init -)"

# Prefer GNU binaries to Macintosh binaries.
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

# Add datadog devtools binaries to the PATH
export PATH="$HOME/dd/devtools/bin:$PATH"

# Point GOPATH to our go sources
export GOPATH="$HOME/go"

# Add binaries that are go install-ed to PATH
export PATH="$GOPATH/bin:$PATH"

# Point DATADOG_ROOT to ~/dd symlink
export DATADOG_ROOT="$HOME/dd"

# Tell the devenv vm to mount $GOPATH/src rather than just dd-go
export MOUNT_ALL_GO_SRC=1

# store key in the login keychain instead of aws-vault managing a hidden keychain
export AWS_VAULT_KEYCHAIN_NAME=login

# tweak session times so you don't have to re-enter passwords every 5min
export AWS_SESSION_TTL=24h
export AWS_ASSUME_ROLE_TTL=1h

# Helm switch from storing objects in kubernetes configmaps to
# secrets by default, but we still use the old default.
export HELM_DRIVER=configmap

# Go 1.16+ sets GO111MODULE to off by default with the intention to
# remove it in Go 1.18, which breaks projects using the dep tool.
# https://blog.golang.org/go116-module-changes
export GO111MODULE=auto
export GOPRIVATE=github.com/DataDog
# Configure Go to pull go.ddbuild.io packages.
export GOPROXY=binaries.ddbuild.io,https://proxy.golang.org,direct
export GONOSUMDB=github.com/DataDog,go.ddbuild.io
# END ANSIBLE MANAGED BLOCK
# BEGIN DATA-ENG-TOOLS MANAGED BLOCK
# Add data-eng-tools binaries and helpers to the path
export PATH="${DATADOG_ROOT}/data-eng-tools/bin:${PATH?}"
source ${DATADOG_ROOT}/data-eng-tools/dotfiles/helpers
export DYLD_LIBRARY_PATH=/usr/local/opt/openssl/lib
# END DATA-ENG-TOOLS MANAGED BLOCK
# BEGIN DD-ANALYTICS MANAGED BLOCK
# Add required dd-analytics binaries to the path
if [ -z "$LIBRARY_PATH" ]
then
    export LIBRARY_PATH="/opt/homebrew/opt/openssl/lib/"
else
    export LIBRARY_PATH="/opt/homebrew/opt/openssl/lib/:${LIBRARY_PATH?}"
fi

alias j11="export JAVA_HOME=\`/usr/libexec/java_home -v 11\`; java -version"
alias j17="export JAVA_HOME=\`/usr/libexec/java_home -v 17\`; java -version"
alias j21="export JAVA_HOME=\`/usr/libexec/java_home -v 21\`; java -version"

# Set java 11 as default
export JAVA_HOME=`/usr/libexec/java_home -v 11`

# For Spark 3.5.2:
export SCALA_HOME="/opt/homebrew/opt/scala@2.12/"
export PATH=$PATH:$SCALA_HOME/bin
export SPARK_HOME=/usr/local/src/spark-3.5.2-bin-hadoop3
export PATH=$PATH:$SPARK_HOME/bin
# Python and Virtualenv Paths
export PATH="/opt/homebrew/opt/virtualenv/bin:$PATH"

# Add dda-cli to the PATH
export PATH=$PATH:${DATADOG_ROOT}/data-eng-tools/bin
# END DD-ANALYTICS MANAGED BLOCK

# coterm - should appear first on list, before default kubectl installation dir (homebrew)
# export PATH="$HOME/.ddcoterm/overrides:$PATH"
