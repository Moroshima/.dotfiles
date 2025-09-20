#
# ~/.zshenv
#

OS=$(uname)

PROXY_HOST='127.0.0.1'
PROXY_HTTP_PORT='7890'
PROXY_SOCKS_PORT='7890'

if [[ $OS == 'Darwin' ]]; then
    # Disable the save/restore mechanism support for terminal, please refer to /etc/bashrc_Apple_Terminal for detail.
    SHELL_SESSIONS_DISABLE=1
fi
