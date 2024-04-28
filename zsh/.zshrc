#
# ~/.zshrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ll='ls -l'
alias l.='ls -d .*'

# Set an alias for 'cp' to make it interactive and preserve file attributes by default
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

alias md5sum='md5 -r'
alias sha1sum='shasum -a 1'
alias sha224sum='shasum -a 224'
alias sha256sum='shasum -a 256'
alias sha384sum='shasum -a 384'
alias sha512sum='shasum -a 512'

alias 7z='7zz'

HISTSIZE=20000
SAVEHIST=10000

# When writing out the history file, by default zsh uses ad-hoc file locking to avoid known problems with locking on some operating systems. With this option locking is done by means of the system’s fcntl call, where this method is available. On recent operating systems this may provide better performance, in particular avoiding history corruption when files are stored on NFS.
setopt HIST_FCNTL_LOCK
# If a new command line being added to the history list duplicates an older one, the older command is removed from the list (even if it is not the previous event).
setopt HIST_IGNORE_ALL_DUPS
# Remove superfluous blanks from each command line being added to the history list.
setopt HIST_REDUCE_BLANKS
# Do not query the user before executing ‘rm *’ or ‘rm path/*’.
setopt RM_STAR_SILENT

# Lazyload function from https://github.com/qoomon/zsh-lazyload/blob/master/zsh-lazyload.zsh
function lazyload {
  local seperator='--'
  local seperator_index=${@[(ie)$seperator]}
  local cmd_list=(${@:1:(($seperator_index - 1))});
  local load_cmd=${@[(($seperator_index + 1))]};

  if [[ ! $load_cmd ]]; then
    >&2 echo "[ERROR] lazyload: No load command defined"
    >&2 echo "  $@"
    return 1
  fi

  # check if lazyload was called by placeholder function
  if (( ${cmd_list[(Ie)${funcstack[2]}]} )); then
    unfunction $cmd_list
    eval "$load_cmd"
  else
    # create placeholder function for each command
    local cmd
    for cmd in $cmd_list; eval "function $cmd { lazyload $cmd_list $seperator ${(qqqq)load_cmd} && $cmd \"\$@\" }"
  fi
}

### Notes ###
# ${funcstack[2]}      resolves to the caller function name
# ${ARRAY[(Ie)$value]} resolves to the index of the VALUE within the ARRAY (I - Index; e - exact match, no pattern match)
# (($NUMBER))          resolves to false for NUMBER 0, else true
# ${(qqqq)VAR}         resolves to quoted value in the format of $'...'

export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
export HOMEBREW_AUTOREMOVE=1
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"


export NVM_DIR="$HOME/.nvm"
lazyload nvm node corepack npm npx yarn pnpm pnpx -- '
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
'

export NVM_NODEJS_ORG_MIRROR="https://mirrors.ustc.edu.cn/node"

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

if type brew &>/dev/null; then
    BREW_PREFIX=$(brew --prefix)
    FPATH=$BREW_PREFIX/share/zsh/site-functions:$BREW_PREFIX/share/zsh-completions:$FPATH:w

    autoload -Uz compinit
    compinit
fi

# Load Zsh plugins
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Enable colorized output for ls
export CLICOLOR=1
