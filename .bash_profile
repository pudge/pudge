umask 0002

[[ -r ~/.bashrc ]] && . ~/.bashrc


if [[ $(uname) == 'Linux' ]]; then
    if [ -f ~/.ssh_agent_start.sh ]; then
        . ~/.ssh_agent_start.sh
    fi
fi
