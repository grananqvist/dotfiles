eval "$(/opt/homebrew/bin/brew shellenv)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
conda activate base

#### Added by green-restore install-tools
autoload -Uz compinit && compinit
####

bindkey -r '^L'

# Source files with secrets and local machine env. Not added to git.
[[ -f ~/.bashrc ]] && source ~/.bashrc # ghcup-env
[[ -f ~/.secrets ]] && source ~/.secrets

export PATH="/opt/homebrew/opt/llvm@12/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm@12/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm@12/include"

#export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
#export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
#export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

# Cardano
export PATH=$PATH:~/cardano-node-1.35.5-macos
export PATH=$PATH:~/cardano-wallet-v2022-07-01-macos-intel/
if command -v cardano-address &> /dev/null; then
    source <(cardano-address --bash-completion-script $(which cardano-address))
fi
export PATH=$PATH:/Users/fgranqvist/.local/bin
export PATH=$PATH:/Users/system/.local/bin

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/system/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/Users/system/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/system/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/system/Downloads/google-cloud-sdk/completion.bash.inc'; fi

# Load Cargo environment if the file exists
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"
export PATH="/opt/homebrew/opt/node@14/bin:$PATH"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export PATH="/opt/homebrew/opt/node@16/bin:$PATH"
export PATH="/opt/homebrew/opt/qt@5/bin:$PATH"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# Dotfiles git command
alias dots='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

source ~/github/git-subrepo/.rc
