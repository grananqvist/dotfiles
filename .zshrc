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
# Fuzzy search
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
export PATH="/opt/homebrew/opt/node@16/bin:$PATH"
export PATH="/opt/homebrew/opt/qt@5/bin:$PATH"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# Dotfiles git command
alias dots='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

source ~/github/git-subrepo/.rc
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

#### Unified Local Zsh History (tmux + fzf friendly) ####

# One history file per machine (avoid cross-host sharing)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000

# Shared + safe history behavior
setopt INC_APPEND_HISTORY          # append immediately, not on exit
setopt SHARE_HISTORY               # share history among all local shells
setopt EXTENDED_HISTORY            # add timestamp + duration
setopt HIST_FCNTL_LOCK             # avoid concurrent corruption
setopt HIST_SAVE_BY_COPY           # safer when writing while others read
setopt HIST_IGNORE_DUPS            # drop direct duplicates
setopt HIST_IGNORE_ALL_DUPS        # drop duplicates anywhere, earlier ones erased
setopt HIST_IGNORE_SPACE           # commands starting with space not saved
setopt APPEND_HISTORY              # explicitly append mode

# Flush history to disk before every prompt (critical for tmux-resurrect)
autoload -Uz add-zsh-hook
_zsh_hist_flush() { fc -AI }       # write + timestamp update
add-zsh-hook precmd _zsh_hist_flush


#### fzf Ctrl-R that sees history from all panes immediately ####

# This overrides the fzf-history-widget to reload history first
_fzf_history_with_reload() {
  builtin fc -R                    # merge new history lines from disk
  zle fzf-history-widget           # then run fzf search
}
zle -N _fzf_history_with_reload
bindkey '^R' _fzf_history_with_reload

