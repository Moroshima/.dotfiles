#
# ~/.zprofile
#

if [[ $OS == 'Darwin' ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
