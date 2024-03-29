eval "$(/opt/homebrew/bin/brew shellenv)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.bash' 'hook' 2>/dev/null)"
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

[[ -f ~/.bashrc ]] && source ~/.bashrc # ghcup-env

# Source file with secrets. Not added to git.
[[ -f ~/.bashrc ]] && source ~/.secrets

export PATH="/opt/homebrew/opt/llvm@12/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm@12/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm@12/include"

#export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
#export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
#export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

# Cardano
export PATH=$PATH:~/cardano-node-1.35.5-macos
export PATH=$PATH:~/cardano-wallet-v2022-07-01-macos-intel/
source <(cardano-address --bash-completion-script $(which cardano-address))
export PATH=$PATH:/Users/system/.local/bin

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/system/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/Users/system/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/system/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/system/Downloads/google-cloud-sdk/completion.bash.inc'; fi
. "$HOME/.cargo/env"

# Download trade from deployment. $1=hostname $2=ticker $3=txid
dl_trade() {
	scp -r -i ~/.ssh/macbook_m1 ${1}:/root/cardano-arb/trades/${2}/${3} ~/Downloads/cardano-arb-debug/trades/${3}
}
export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"
export PATH="/opt/homebrew/opt/node@14/bin:$PATH"

dl_logs() {
	cd ~/Downloads/cardano-arb-debug/
	mkdir -p $1
	cd $1
	scp dream-us:~/dream_logs/${1}/* .
	scp dream-hz1:~/dream_logs/${1}/* .
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export PATH="/opt/homebrew/opt/node@16/bin:$PATH"
export PATH="/opt/homebrew/opt/qt@5/bin:$PATH"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# Dotfiles git command
alias dots='/usr/bin/git --git-dir=$HOME/Github/dotfiles/ --work-tree=$HOME'
