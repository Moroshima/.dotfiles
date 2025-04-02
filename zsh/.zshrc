#
# ~/.zshrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

OS=$(uname)

# aliases
alias cp='cp -ip' # set an alias for 'cp' to make it interactive and preserve file attributes by default
alias j=jobs
alias pu=pushd
alias po=popd
alias d='dirs -v'
alias h=history
alias ll='ls -l'
alias la='ls -a'
alias l.='ls -d .*'

# colorize the output of commands below
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

export LESS='--use-color -cDd+r$Du+b$MR'

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath

if [[ $OS == 'Darwin' ]]; then
    # enable colorized output for ls
    export CLICOLOR=1

    # set alias for hash sum commands
    alias md5sum='md5 -r'
    alias sha1sum='shasum -a 1'
    alias sha224sum='shasum -a 224'
    alias sha256sum='shasum -a 256'
    alias sha384sum='shasum -a 384'
    alias sha512sum='shasum -a 512'

    alias 7z='7zz'
    alias b='brew update && brew upgrade'
    alias whereis='whereis -ab'

    tar() {
        for arg in "$@"; do
            # short options
            if [[ "$arg" =~ ^- && ! "$arg" =~ -- ]]; then
                letters="${arg:1}"
                for letter in $(echo "$letters" | sed -e 's/\(.\)/\1 /g'); do
                    case "$letter" in
                        t) break ;;
                        x) local addflags="--no-mac-metadata --no-xattrs"; break ;;
                        *) local addflags="--no-xattrs"; break ;;
                    esac
                done
                break
            fi

            # long options
            case "$arg" in
                "--list") break ;;
                "--extract") local addflags="--no-mac-metadata --no-xattrs"; break ;;
                *) local addflags="--no-xattrs"; break ;;
            esac
        done

        command tar $addflags "$@"
    }
elif [[ $OS == 'Linux' ]]; then
    alias ip='ip -color=auto'
    alias ls='ls --color=auto'
    alias whereis='whereis -b'

    export MANPAGER='less -R --use-color -Dd+r -Du+b'
    # grotty from groff >1.23.0 requires "-c" option to output overstricken output instead of ansi escapes. less relies on the overstrike formatting to apply its color options, so we need man to pass this option when formatting the man pages for customization to be effective.
    if nroff --version | awk '{split($NF,v,"."); exit !(v[1]>1 || (v[1]==1 && v[2]>=32))}'; then
        export MANROFFOPT='-P -c'
    fi
fi

setopt   MENU_COMPLETE        # On an ambiguous completion, instead of listing possibilities or beeping, insert the first match immediately. Then when completion is requested again, remove the first match and insert the second match, etc. When there are no more matches, go back to the first one again. reverse-menu-complete may be used to loop through the list in the other direction. This option overrides AUTO_MENU.
setopt   HIST_FCNTL_LOCK      # When writing out the history file, by default zsh uses ad-hoc file locking to avoid known problems with locking on some operating systems. With this option locking is done by means of the system’s fcntl call, where this method is available. On recent operating systems this may provide better performance, in particular avoiding history corruption when files are stored on NFS.
setopt   HIST_IGNORE_ALL_DUPS # If a new command line being added to the history list duplicates an older one, the older command is removed from the list (even if it is not the previous event).
setopt   HIST_REDUCE_BLANKS   # Remove superfluous blanks from each command line being added to the history list.
setopt   RM_STAR_SILENT       # Do not query the user before executing ‘rm *’ or ‘rm path/*’.
unsetopt AUTO_PARAM_SLASH     # If a parameter is completed whose content is the name of a directory, then add a trailing slash instead of a space.

if [[ $OS == 'Linux' ]]; then
    # configure the zsh history settings
    HISTFILE="$HOME/.zsh_history"
    HISTSIZE=2000
    SAVEHIST=1000

    # load and initialize the command completion system
    autoload -Uz compinit
    compinit
fi

# the implementation of the 'proxy' function to export/unset the proxy environment variables
proxy() {
    PROXY_HOST='127.0.0.1'
    PROXY_PORT='7890'
    PROXY_SOCKS_PORT='7890'

    if [[ "$*" == 'enable' ]]; then
        if [[ $HTTP_PROXY && $HTTPS_PROXY && $ALL_PROXY && $http_proxy && $https_proxy && $all_proxy ]]; then
            echo 'proxy already enabled!'
        else
            export {HTTP_PROXY,http_proxy}="http://$PROXY_HOST:$PROXY_PORT"
            export {HTTPS_PROXY,https_proxy}="http://$PROXY_HOST:$PROXY_PORT"
            export {ALL_PROXY,all_proxy}="socks5://$PROXY_HOST:$PROXY_SOCKS_PORT"
            echo 'proxy enabled!'
        fi
    elif [[ "$*" == 'disable' ]]; then
        if [[ $HTTP_PROXY || $HTTPS_PROXY || $ALL_PRXOY || $http_proxy || $https_proxy || $all_proxy ]]; then
            unset {HTTP_PROXY,http_proxy}
            unset {HTTPS_PROXY,https_proxy}
            unset {ALL_PROXY,all_proxy}
            echo 'proxy disabled!'
        else
            echo 'proxy already disabled!'
        fi
    elif [[ "$*" == 'status' ]]; then
        if [[ $HTTP_PROXY || $HTTPS_PROXY || $ALL_PROXY || $http_proxy || $https_proxy || $all_proxy ]]; then
            echo "HTTP_PROXY=${HTTP_PROXY:-'none'}"
            echo "HTTPS_PROXY=${HTTPS_PROXY:-'none'}"
            echo "ALL_PROXY=${ALL_PROXY:-'none'}"
            echo "http_proxy=${http_proxy:-'none'}"
            echo "https_proxy=${https_proxy:-'none'}"
            echo "all_proxy=${all_proxy:-'none'}"
        else
            echo 'proxy is disabled!'
        fi
    elif [[ "$*" == 'help' ]] || [[ "$*" == '' ]]; then
        echo 'usage: proxy [enable|disable|status|help]'
    else
        printf "invalid command name \"%s\".\n" "$*" >&2
    fi
}
# enable the proxy environment variables by default
proxy enable > /dev/null 2>&1

# clean up the cache of various package managers
clean() {
    declare -A array
    array=(
        [npm]='npm cache clean --force'
        [yarn]='yarn cache clean'
        [pip3]='pip3 cache purge'
        [pnpm]='pnpm store prune'
    )

    if [[ $OS == 'Darwin' ]]; then
        array+=(
            [brew]='brew cleanup'
        )
    fi

    if [[ $OS == 'Darwin' ]]; then
        local symbol='==>'
    else
        local symbol='::'
    fi

    for command in ${(on)${(k)array}}; do
        printf "\033[0;34m%s\033[0m \033[1mClearing the \033[32m%s\033[39m cache...\033[0m\n" "$symbol" "${(k)array[$command]}"
        if [ "$(command -v $command)" ]; then
            eval ${array[$command]}
        else
            printf "\033[1;31mcommand \"%s\" does not exist on system.\033[0m\n" "$command" >&2
            printf "\033[0;34m%s\033[0m Do you want to continue with the cleanup process? [Y/n] " "$symbol"
            read choice
            case "$choice" in
                [Yy]* | "") continue ;;
                [Nn]*) echo "cleanup process aborted!" >&2; return 1 ;;
                *) echo "invalid input. cleanup process aborted!" >&2; return 1 ;;
            esac
        fi
    done
    echo 'all cleanup tasks have been done!'
}

normalize() {
    if [[ $OS == 'Darwin' ]]; then
        local symbol='==>'
    else
        local symbol='::'
    fi

    local array=('.DS_Store' 'Thumbs.db' '._*' '*:Zone.Identifier')

    printf "\033[0;34m%s\033[0m Are you sure you want to normalize %s? This will change the files and dirs mode and delete these unwanted files: %s [Y/n] " "$symbol" "$(pwd)" "${array[*]}"
    read normalize_choice
    case "$normalize_choice" in
        [Yy]* | "") ;;
        [Nn]*) echo "normalization process aborted!" >&2; return 1 ;;
        *) echo "invalid input. normalization process aborted!" >&2; return 1 ;;
    esac

    printf "\033[0;34m%s\033[0m Are you sure you want to change the files and dirs mode? [Y/n] " "$symbol"
    read chmod_choice
    case "$chmod_choice" in
        [Yy]* | "")
            printf "\033[0;34m%s\033[0m \033[1mChanging the \033[32mfiles\033[39m mode...\033[0m\n" "$symbol"
            find . -type f -exec chmod 644 "{}" \;
            printf "\033[0;34m%s\033[0m \033[1mChanging the \033[32mdirs\033[39m mode...\033[0m\n" "$symbol"
            find . -type d -exec chmod 755 "{}" \;
            ;;
        [Nn]*) echo "normalization process aborted!" >&2; return 1 ;;
        *) echo "invalid input. normalization process aborted!" >&2; return 1 ;;
    esac

    for name in "${array[@]}"; do
        printf "\033[0;34m%s\033[0m \033[1mSearching \033[32m%s\033[39m files...\033[0m\n" "$symbol" "$name"
        find . -name "$name" -type f
        printf "\033[0;34m%s\033[0m Are you sure you want to \033[1;31mdelete\033[0m these \"%s\" files? [Y/n] " "$symbol" "$name"
        read delete_choice
        case "$delete_choice" in
            [Yy]* | "") find . -name "$name" -type f -exec echo "Deleting: {}" \; -delete ;;
            [Nn]*)
                printf "\033[0;34m%s\033[0m Do you want to continue deleting these unwanted files? [Y/n] " "$symbol"
                read delete_continue_choice
                case "$delete_continue_choice" in
                    [Yy]* | "") continue ;;
                    [Nn]*) echo "normalization process aborted!" >&2; return 1 ;;
                    *) echo "invalid input. normalization process aborted!" >&2; return 1 ;;
                esac
            ;;
            *) echo "invalid input. normalization process aborted!" >&2; return 1 ;;
        esac
    done

    echo "normalization process completed!"
}

eval "$(starship init zsh)"

if [[ $OS == 'Darwin' ]]; then
    export HOMEBREW_API_DOMAIN="https://mirrors.bfsu.edu.cn/homebrew-bottles/api"
    export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.bfsu.edu.cn/homebrew-bottles"
    export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.bfsu.edu.cn/git/homebrew/brew.git"

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

    NODE_VERSION=22

    export PATH="/opt/homebrew/opt/node@$NODE_VERSION/bin:$PATH"

    # for compilers to find node
    export LDFLAGS="-L/opt/homebrew/opt/node@$NODE_VERSION/lib"
    export CPPFLAGS="-I/opt/homebrew/opt/node@$NODE_VERSION/include"
elif [[ $OS == 'Linux' ]]; then
    # load zsh plugins via different paths based on the linux distro
    case $(awk -F= '/^ID=/{print $2}' /etc/os-release) in
      arch)
            source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
            source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
            ;;
      debian)
            source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
            source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
            ;;
      *) echo "unknown linux distro, zsh plugins cannot be loaded" >&2 ;;
    esac
fi
