# PATH environment variable modifications should be made here.

export PATH="${PATH}:$(go env GOPATH)/bin"
export PATH="${PATH}:/Applications/IntelliJ IDEA.app/Contents/MacOS"
export PATH="${PATH}:${ZDOTDIR}/git_functions"

# >>> coursier install directory >>>
export PATH="$PATH:$(echo $HOME)/Library/Application Support/Coursier/bin"
# <<< coursier install directory <<<

export PATH="$PATH:$HOME/.local/bin"
