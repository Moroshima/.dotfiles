#!/bin/zsh
set -euo pipefail

# .stow-global-ignore file should be stowed first to prevent .DS_Store from being stowed
stow -v stow

# emacs will not create .emacs.d dir automatically, so it's safe to assume that
# the directory doesn't exist and just simply stow .emacs.d.
stow -v emacs git npm

stow -v vim
# intall vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir -pv ~/.config/mpv  # this step also ensures ~/.config dir exists
stow -v mpv
# install keep-session.lua script
curl --output-dir ~/.config/mpv/scripts --create-dirs \
    -O https://raw.githubusercontent.com/Moroshima/mpv-scripts/refs/heads/master/keep-session.lua

mkdir -pv ~/.ssh
stow -v ssh

# compile zsh functions for better performance
zcompile -R zsh/.zshrc.d/functions.zwc zsh/.zshrc.d/functions/*(.N)
# ~/.config dir already exists when stowing zsh
stow -v zsh