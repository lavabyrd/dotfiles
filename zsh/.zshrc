
export ZSH="/Users/markpreston/.oh-my-zsh"

plugins=(postgres autojump web-search )
ZSH_DISABLE_COMPFIX=true
ENABLE_CORRECTION="true"
autoload -U promptinit; promptinit
source $ZSH/oh-my-zsh.sh
source <(kubectl completion zsh)

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
export PATH="$HOME/go/bin:$PATH"
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH" # openssl path
export PATH="$HOME/.cargo/bin:$PATH" # rust path
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
# configs
alias zr="source ~/.zshrc"
alias zc="nvim ~/.zshrc"
alias nc="nvim ~/.config/nvim/init.vim"
alias tc="nvim ~/.tmux.conf"
alias tr="tmux source-file ~/.tmux.conf"
alias ou="omz update"

# shortcuts
alias fls="eza | fzf"
alias ls="eza --all --all --long --header --git --icons"
alias tree="eza --list --header --git --icons"
alias curl="noglob curl" # stops curl query params from needing to be in ""
alias gundo="git reset HEAD~;" # unstage files and commits
alias gst="git status"
alias lg="lazygit"
alias python="python3.11"
alias pip="pip3"
alias n="nvim"
alias vim="nvim"
alias td="tmux detach"
alias tls="tmux ls"
alias tp="tmux attach -t personal"
alias tw="tmux attach -t work"
alias c="code ."
alias kc="kubectx"
alias kn="kubens"
alias f="fzf"
alias fh="history | fzf +s --tac"
alias dclean="docker container rm -f $(docker container ls -aq)"

nd () {
  mkdir -p -- "$1" &&
  cd -P -- "$1"
}

clu () {
  selected_image=$(eza -D | fzf --height=50% --border --margin=1 --padding=1)
  outp=$(echo $selected_image | xargs -I {} sed -n '1 s/^[^ ]* // p' {}/Dockerfile)
  IFS=':', read -r image original_tag <<< "$outp"
  echo "Image: $outp"
  updated_tag=$(crane ls --platform=linux/amd64 $image --omit-digest-tags | fzf --query "$original_tag" --height=50% --border --margin=1 --padding=1)
  original_sha=$(crane digest --platform=linux/amd64 $image:$original_tag)
  IFS=':', read -r sha original_sha <<< "$original_sha"
  updated_sha=$(eval "crane digest --platform=linux/amd64 $image:$updated_tag")
  IFS=':', read -r sha updated_sha <<< "$updated_sha"
  echo "\n\n$image:$updated_tag \n\nSHA: $updated_sha"
  echo "$updated_sha" | pbcopy
  sed -i '' "s/$original_tag/$updated_tag/g" "$selected_image"/Dockerfile 
  if [[ $original_tag == v* ]]; then
    sed -i '' "s/${original_tag#v}/${updated_tag#v}/g" "$selected_image"/build.yaml
  else
    sed -i '' "s/$original_tag/$updated_tag/g" "$selected_image"/build.yaml
  fi
  sed -i '' "s/$original_sha/$updated_sha/g" "$selected_image"/Dockerfile
}

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
load_source_files ~/.keys

eval "$(pyenv init --path)"
eval "$(rbenv init - zsh)"
eval "$(starship init zsh)"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
