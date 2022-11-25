
export ZSH="/Users/markpreston/.oh-my-zsh"

plugins=(postgres autojump web-search)
ZSH_DISABLE_COMPFIX=true
ENABLE_CORRECTION="true"
autoload -U promptinit; promptinit
source $ZSH/oh-my-zsh.sh

MAILCHECK=0

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}
export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
export GOPATH=$HOME/go
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH" # openssl path
export PATH=$PATH:$GOPATH/bin # go path
export PATH="$HOME/.cargo/bin:$PATH" # rust path
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export NVM_DIR=~/.nvm

# configs
alias zr="source ~/.zshrc"
alias zc="nvim ~/.zshrc"
alias nvc="nvim ~/.config/nvim/init.vim"
alias tmc="nvim ~/.tmux.conf"
alias tr="tmux source-file ~/.tmux.conf"

# shortcuts
alias ls="exa --all --all --long --header --git --icons"
alias tree="exa --list --header --git --icons"
alias curl="noglob curl" # stops curl query params from needing to be in ""
alias vim="nvim"
alias gundo="git reset HEAD~;" # unstage files and commits
alias gst="git status"
alias lg="lazygit"
alias python="python3.11"

load_source_files () {
  if [[ -f $1 && -r $1 ]]; then
    echo successfully loaded $1
    source $1
  else
    echo failed to load $1
  fi
}

# Load source files if present
load_source_files $(brew --prefix nvm)/nvm.sh
load_source_files ~/.work
load_source_files /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
load_source_files ~/.keys

eval "$(pyenv init --path)"
eval "$(rbenv init - zsh)"
eval "$(starship init zsh)"

if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
  load_source_files ~/.fzf.zsh
#   [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi
