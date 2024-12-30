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

create the service file

```bash
sudo vim /etc/systemd/system/qbittorrent-restart.service
```

put the following content in the file

```text
[Service]
Type=oneshot
ExecStart=/usr/bin/systemctl try-restart qbittorrent-nox@moroshima.service
```

create the timer file

```bash
sudo vim /etc/systemd/system/qbittorrent-restart.timer
```

put the following content in the file

```text
[Unit]
Description=Restart qBittorrent Service

[Timer]
OnCalendar=*-*-* 04:00:00

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

check whether the service is triggered by scheduler

```bash
sudo systemctl status qbittorrent-restart.service
```

### Reference

[Systemd 定时器教程 - 阮一峰的网络日志](https://www.ruanyifeng.com/blog/2018/03/systemd-timer.html)
[systemd.time](https://www.freedesktop.org/software/systemd/man/latest/systemd.time.html)
[linux - How can I configure a systemd service to restart periodically? - Stack Overflow](https://stackoverflow.com/a/40229577)