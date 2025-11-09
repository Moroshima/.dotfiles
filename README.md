# .dotfiles

Use GNU Stow to manage dotfiles.

## Quick start

```bash
cd ~
git clone git@github.com:Moroshima/.dotfiles.git
cd ~/.dotfiles
chmod +x one-click.sh
./one-click.sh
```

## Homebrew

```bash
brew bundle  # install packages
brew bundle dump --describe --formula --cask --tap -f  # update Brewfile
```

## Vim

use `:PlugInstall` to install the plugins

## Other config files

| filename        | introduction                                                  |
| --------------- | ------------------------------------------------------------- |
| Hibiki.terminal | Configuration file for customizing settings in Apple Terminal |
| settings.json   | Windows Terminal settings                                     |
| Brewfile        | Homebrew bundle file                                          |

## Memo

### Homebrew

replace Apple diff with diffutils due to [oh my zsh - Autocomplete of diff command not working in zsh / oh-my-zsh - Unix & Linux Stack Exchange](https://unix.stackexchange.com/a/768178)

#### duplicates

[Pressing TAB does not trigger autocomplete for the 2nd argument of diff · Issue #11416 · ohmyzsh/ohmyzsh](https://github.com/ohmyzsh/ohmyzsh/issues/11416)

[Tab completion for second filename not working for `diff` · Issue #11454 · ohmyzsh/ohmyzsh](https://github.com/ohmyzsh/ohmyzsh/issues/11454)

### Terminal & Shell

[macos - How can I configure Mac Terminal to have color ls output? - Ask Different](https://apple.stackexchange.com/questions/33677/how-can-i-configure-mac-terminal-to-have-color-ls-output)
