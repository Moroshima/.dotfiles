# https://github.com/qoomon/zsh-lazyload/blob/master/zsh-lazyload.zsh
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

export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"

export NVM_DIR="$HOME/.nvm"
lazyload nvm node corepack npm npx yarn pnpm -- '
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
'

export NVM_NODEJS_ORG_MIRROR="https://mirrors.ustc.edu.cn/node/"

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
