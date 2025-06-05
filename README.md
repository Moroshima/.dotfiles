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
stow mpv
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

intall [junegunn/vim-plug: :hibiscus: Minimalist Vim Plugin Manager](https://github.com/junegunn/vim-plug)

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

then use `:PluginInstall` to install the plugins

# mpv

install keep-session.lua script

```bash
curl --output-dir ~/.config/mpv/scripts -O https://raw.githubusercontent.com/CogentRedTester/mpv-scripts/refs/heads/master/keep-session.lua
```

## Other configurations

| file            | introduction                                                  |
| --------------- | ------------------------------------------------------------- |
| Hibiki.terminal | Configuration file for customizing settings in Apple Terminal |
| settings.json   | Windows Terminal settings                                     |
| Brewfile        | Homebrew bundle file                                          |

## Firefox

### Extensions

- uBlock Origin
- User-Agent Switcher
- 沉浸式翻译
- Tampermonkey
    - [ChatGPT降级检测](https://github.com/KoriIku/chatgpt-degrade-checker)
    - [中国大学慕课mooc答题/自动播放脚本(domooc)](https://domooc.top/domoocreadme)
    - [动车组交路查询](https://rail.re/)
    - [红色有角三倍速](https://greasyfork.org/zh-CN/scripts/529702-%E7%BA%A2%E8%89%B2%E6%9C%89%E8%A7%92%E4%B8%89%E5%80%8D%E9%80%9F)
- Auto Tab Discard
- Wappalyzer
- Jiffy Reader
- Wayback Machine
- DeepL
- uBlacklist
- Notion Web Clipper
- PT Plugin Plus
- 猫抓

extension below are disabled

- 划词翻译
- Plasma Integration
- Relingo
- Ruffle
    - www.icourse163.com won't render home page with ruffle enabled

#### Configuration files

| file                              | introduction                   |
| --------------------------------- | ------------------------------ |
| auto-tab-discard-preferences.json | Auto Tab Discard configuration |
| ublacklist-settings.json          | uBlacklist configuration       |
| uBlacklist.txt                    | Websites blocked by uBlacklist |

## Notes

### macOS

#### Homebrew

##### diff

replace Apple diff with diffutils due to [oh my zsh - Autocomplete of diff command not working in zsh / oh-my-zsh - Unix & Linux Stack Exchange](https://unix.stackexchange.com/a/768178)

###### duplicates

- [Pressing TAB does not trigger autocomplete for the 2nd argument of diff · Issue #11416 · ohmyzsh/ohmyzsh](https://github.com/ohmyzsh/ohmyzsh/issues/11416)
- [Tab completion for second filename not working for `diff` · Issue #11454 · ohmyzsh/ohmyzsh](https://github.com/ohmyzsh/ohmyzsh/issues/11454)

#### Terminal & Shell

[macos - How can I configure Mac Terminal to have color ls output? - Ask Different](https://apple.stackexchange.com/questions/33677/how-can-i-configure-mac-terminal-to-have-color-ls-output)

### Linux

#### qBittorrent

##### Restart qBittorrent service periodically under linux

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
Description=Restart qBittorrent Service Automatically

[Timer]
OnCalendar=*-*-* 04:00:00

[Install]
WantedBy=timers.target
```

then reload systemd and enable the timer

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now qbittorrent-restart.timer
```

check the status of the timer

```bash
sudo systemctl status qbittorrent-restart.timer
```

check whether the service is triggered by scheduler

```bash
sudo systemctl status qbittorrent-restart.service
```

###### Reference

- [Systemd 定时器教程 - 阮一峰的网络日志](https://www.ruanyifeng.com/blog/2018/03/systemd-timer.html)
- [systemd.time](https://www.freedesktop.org/software/systemd/man/latest/systemd.time.html)
- [linux - How can I configure a systemd service to restart periodically? - Stack Overflow](https://stackoverflow.com/a/40229577)
