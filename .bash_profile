
# added by Anaconda3 4.4.0 installer
export PATH="/anaconda/bin:$PATH"
export PATH="~/google-cloud-sdk/bin:$PATH"

# GOPATHS
export GOPATH=~/go:~/Github/MyTradingBook/go


#alias tmux="TERM-screen-256color-bce tmux"
#if [[ $TERM == xterm ]]; then
#	TERM=xterm-255color	
#fi


##
# Your previous /Users/system/.bash_profile file was backed up as /Users/system/.bash_profile.macports-saved_2017-10-05_at_19:04:08
##

# MacPorts Installer addition on 2017-10-05_at_19:04:08: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
export PATH="~/go/bin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.


export PATH="$HOME/.cargo/bin:$PATH"
alias sshposeg="CLOUDSDK_ACTIVE_CONFIG_NAME=poseg-config gcloud compute ssh cloud_smart_eye2@instance-1"

alias jtags="ctags -R . && sed -i '' -E '/^(if|switch|function|module\.exports|it|describe).+language:js$/d' tags"
