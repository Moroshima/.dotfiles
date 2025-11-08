#
# ~/.zshenv
#

if [[ $(uname) == 'Darwin' ]]; then
    # Disable the save/restore mechanism support for terminal, please refer to /etc/bashrc_Apple_Terminal for detail.
    SHELL_SESSIONS_DISABLE=1
fi
