#
# ~/.zshrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

KERNEL=$(uname)

alias ll='ls -l'
alias l.='ls -d .*'

# set an alias for 'cp' to make it interactive and preserve file attributes by default
alias cp='cp -ip'

alias grep='grep --color=auto'
alias egrep='grep -E --color=auto'
alias fgrep='grep -F --color=auto'

alias xzgrep='xzgrep --color=auto'
alias xzegrep='xzegrep --color=auto'
alias xzfgrep='xzfgrep --color=auto'

alias zgrep='zgrep --color=auto'
alias zfgrep='zfgrep --color=auto'
alias zegrep='zegrep --color=auto'

alias diff='diff --color=auto'
alias ip='ip -color=auto'

export LESS='-R --use-color -Dd+r$Du+b$'
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export MANROFFOPT="-P -c"

if [[ $KERNEL == 'Darwin' ]]; then
	# enable colorized output for ls
	export CLICOLOR=1

	alias md5sum='md5 -r'
	alias sha1sum='shasum -a 1'
	alias sha224sum='shasum -a 224'
	alias sha256sum='shasum -a 256'
	alias sha384sum='shasum -a 384'
	alias sha512sum='shasum -a 512'

	alias 7z='7zz'
elif [[ $KERNEL == 'Linux' ]]; then
	alias ls='ls --color=auto'
fi

# When writing out the history file, by default zsh uses ad-hoc file locking to avoid known problems with locking on some operating systems. With this option locking is done by means of the system’s fcntl call, where this method is available. On recent operating systems this may provide better performance, in particular avoiding history corruption when files are stored on NFS.
setopt HIST_FCNTL_LOCK
# If a new command line being added to the history list duplicates an older one, the older command is removed from the list (even if it is not the previous event).
setopt HIST_IGNORE_ALL_DUPS
# Remove superfluous blanks from each command line being added to the history list.
setopt HIST_REDUCE_BLANKS
# Do not query the user before executing ‘rm *’ or ‘rm path/*’.
setopt RM_STAR_SILENT

if [[ $KERNEL == 'Linux' ]]; then
	# configure the zsh history settings
	HISTFILE="$HOME/.zsh_history"
	HISTSIZE=2000
	SAVEHIST=1000

	# load and initialize the command completion system
	autoload -Uz compinit
	compinit
fi

PROXY_HOST="127.0.0.1"
PROXY_PORT="7890"
PROXY_SOCKS_PORT="7890"

export {HTTP_PROXY,http_proxy}="http://$PROXY_HOST:$PROXY_PORT"
export {HTTPS_PROXY,https_proxy}="http://$PROXY_HOST:$PROXY_PORT"
export {ALL_PROXY,all_proxy}="socks5://$PROXY_HOST:$PROXY_SOCKS_PORT"

proxy() {
	if [[ $* == "enable" ]]; then
		if [[ $HTTP_PROXY && $HTTPS_PROXY && $ALL_PROXY && $http_proxy && $https_proxy && $all_proxy ]]; then
			echo "proxy already enabled!"
		else
			export {HTTP_PROXY,http_proxy}="http://$PROXY_HOST:$PROXY_PORT"
			export {HTTPS_PROXY,https_proxy}="http://$PROXY_HOST:$PROXY_PORT"
			export {ALL_PROXY,all_proxy}="socks5://$PROXY_HOST:$PROXY_SOCKS_PORT"
			echo "proxy enabled!"
		fi
	elif [[ $* == "disable" ]]; then
		if [[ $HTTP_PROXY || $HTTPS_PROXY || $ALL_PRXOY || $http_proxy || $https_proxy || $all_proxy ]]; then
			unset {HTTP_PROXY,http_proxy}
			unset {HTTPS_PROXY,https_proxy}
			unset {ALL_PROXY,all_proxy}
			echo "proxy disabled!"
		else
			echo "proxy already disabled!"
		fi
	else
		if [[ $HTTP_PROXY || $HTTPS_PROXY || $ALL_PROXY || $http_proxy || $https_proxy || $all_proxy ]]; then
			echo "HTTP_PROXY=${HTTP_PROXY:-'none'}"
			echo "HTTPS_PROXY=${HTTPS_PROXY:-'none'}"
			echo "ALL_PROXY=${ALL_PROXY:-'none'}"
			echo "http_proxy=${http_proxy:-'none'}"
			echo "https_proxy=${https_proxy:-'none'}"
			echo "all_proxy=${all_proxy:-'none'}"
		else
			echo "proxy is disabled!"
		fi
	fi
}

eval "$(starship init zsh)"

if [[ $KERNEL == 'Darwin' ]]; then
	export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
	export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
	export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
	export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"

	BREW_PREFIX=$(brew --prefix)

	if type brew &>/dev/null; then
		FPATH=$BREW_PREFIX/share/zsh/site-functions:$BREW_PREFIX/share/zsh-completions:$FPATH

		autoload -Uz compinit
		compinit
	fi

	# load zsh plugins
	source $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
	source $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

	HB_CNF_HANDLER="$(brew --repository)/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
	if [ -f "$HB_CNF_HANDLER" ]; then
		source "$HB_CNF_HANDLER";
	fi

	export PATH="/opt/homebrew/opt/node@20/bin:$PATH"

	export LDFLAGS="-L/opt/homebrew/opt/node@20/lib"
	export CPPFLAGS="-I/opt/homebrew/opt/node@20/include"
elif [[ $KERNEL == 'Linux' ]]; then
	# load zsh plugins
	source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
	source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
