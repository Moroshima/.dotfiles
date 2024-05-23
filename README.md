# .dotfiles

```bash
cd ~
git clone git@github.com:Moroshima/.dotfiles.git
```

use stow to manage dotfiles

```bash
cd ~/.dotfiles
stow git
stow npm
stow ssh
stow vim
stow zsh
```

## Vim

intall vim-plug

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

## Other configurations

| filename        | purpose                                                       |
| --------------- | ------------------------------------------------------------- |
| Hibiki.terminal | Configuration file for customizing settings in Apple Terminal |
