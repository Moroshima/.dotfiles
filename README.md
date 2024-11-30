# .dotfiles

```bash
cd ~
git clone git@github.com:Moroshima/.dotfiles.git
```

use stow to manage dotfiles

```bash
cd ~/.dotfiles
stow emacs
stow git
stow npm
stow ssh
stow vim
stow zsh
```

## Homebrew

install packages

```bash
brew bundle --no-lock
```

update Brewfile

```bash
brew bundle dump --describe --formula --tap -f
```

## Vim

intall vim-plug

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

## Other configurations

| file                              | introduction                                                  |
| --------------------------------- | ------------------------------------------------------------- |
| Hibiki.terminal                   | Configuration file for customizing settings in Apple Terminal |
| auto-tab-discard-preferences.json | Auto Tab Discard configuration                                |
| uBlacklist.txt                    | Websites blocked by uBlacklist                                |
| settings.json                     | Windows Terminal settings                                     |

## Restart qBittorrent service periodically under linux

> to prevent qBittorrent from meeting the problem of ipv6 tracker 'Cannot assign requested address' error.

create the timer file

```bash
sudo vim /etc/systemd/system/qbittorrent-restart.timer
```

put the following content in the file

```text
[Unit]
Description=Restart qBittorrent Service

[Timer]
OnUnitActiveSec=1d
Unit=qbittorrent-nox@moroshima.service

[Install]
WantedBy=timers.target
```

then reload systemd and enable the timer

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now qbittorrent-nox-moroshima-restart.timer
```

check the status of the timer

```bash
sudo systemctl status qbittorrent-restart.timer
```

### Reference

[Systemd 定时器教程 - 阮一峰的网络日志](https://www.ruanyifeng.com/blog/2018/03/systemd-timer.html)