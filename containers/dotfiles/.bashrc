# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

if [[ -f /workspace/.bashrc ]]; then
    source /workspace/.bashrc
    export HISTFILE=/workspace/.zsh_history
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

if [[ -f /home/deven/.env ]]
then

    source /home/deven/.env

fi

