#
# ~/.zshrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

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

export LESS='--use-color -cMR -Dd+r$Du+b$'

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath

fpath=($HOME/.zsh/functions $fpath)

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

    autoload -Uz tar
elif [[ $OS == 'Linux' ]]; then
    alias ip='ip -color=auto'
    alias ls='ls --color=auto'
    alias whereis='whereis -b'

    export MANPAGER="less $LESS"
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

# proxy: the implementation of the 'proxy' function to export/unset the proxy environment variables
# clean: clean up the cache of various package managers
autoload -Uz help proxy clean normalize

# enable the proxy environment variables by default
proxy enable > /dev/null 2>&1

eval "$(starship init zsh)"

if [[ $OS == 'Darwin' ]]; then
    export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
    export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
    export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn//brew.git"

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
