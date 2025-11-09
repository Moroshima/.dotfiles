# .dotfiles

Use GNU Stow to manage dotfiles.

As stated in the [Stow manual](https://www.gnu.org/software/stow/manual/stow.html#Installing-Packages)

> The default action of Stow is to install a package. This means creating symlinks in the target tree that point into the package tree. Stow attempts to do this with as few symlinks as possible; in other words, if Stow can create a single symlink that points to an entire subtree within the package tree, it will choose to do that rather than create a directory in the target tree and populate it with symlinks.

**Therefore, always verify that the symlink *targets* match your expectations; you can preview changes first with a dry run using `stow -n <package>`.**

## Quick start

```zsh
cd ~
git clone git@github.com:Moroshima/.dotfiles.git
cd ~/.dotfiles
chmod +x one-click.sh
./one-click.sh
```

## Homebrew

```zsh
brew bundle  # install packages
brew bundle dump --describe --formula --cask --tap -f  # update Brewfile
```

## Vim

Use `:PlugInstall` to install the plugins.

## Zsh

Execute the commands below to resolve the `zsh compinit: insecure directories` warning.

```zsh
chmod go-w '/opt/homebrew/share'
chmod -R go-w '/opt/homebrew/share/zsh'
```

## Other config files

| filename        | introduction                                                  |
| --------------- | ------------------------------------------------------------- |
| Hibiki.terminal | Configuration file for customizing settings in Apple Terminal |
| settings.json   | Windows Terminal settings                                     |
| Brewfile        | Homebrew bundle file                                          |

## Memo

### Homebrew

#### PATH

Homebrew binary is added to PATH via `/etc/paths.d/homebrew`.

#### `INSTALL_RECEIPT.json`

> ⚠️ **Warning:** Manually editing `INSTALL_RECEIPT.json` is risky and not recommended. This file is managed internally by Homebrew, and any changes may lead to inconsistent states, broken dependency tracking, or unexpected behavior.

If you still want to change whether a package is marked as installed on request or as a dependency, you can open the `INSTALL_RECEIPT.json` file located in the package’s Cellar directory:

```zsh
vim /opt/homebrew/Cellar/<package_name>/<version>/INSTALL_RECEIPT.json
```

Then, update the `installed_as_dependency` and `installed_on_request` fields to the desired values. **Normally, these two values are opposite to each other.**

```json INSTALL_RECEIPT.json
{
  ...
  "installed_as_dependency": false,
  "installed_on_request": true,
  ...
}
```

#### diffutils

replace Apple diff with diffutils due to [oh my zsh - Autocomplete of diff command not working in zsh / oh-my-zsh - Unix & Linux Stack Exchange](https://unix.stackexchange.com/a/768178)

##### duplicates

[Pressing TAB does not trigger autocomplete for the 2nd argument of diff · Issue #11416 · ohmyzsh/ohmyzsh](https://github.com/ohmyzsh/ohmyzsh/issues/11416)  
[Tab completion for second filename not working for `diff` · Issue #11454 · ohmyzsh/ohmyzsh](https://github.com/ohmyzsh/ohmyzsh/issues/11454)

### Terminal & Shell

[macos - How can I configure Mac Terminal to have color ls output? - Ask Different](https://apple.stackexchange.com/questions/33677/how-can-i-configure-mac-terminal-to-have-color-ls-output)
