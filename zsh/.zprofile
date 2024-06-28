#
# ~/.zprofile
#

KERNEL=$(uname)

if [[ $KERNEL == 'Darwin' ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
