umask 0002

[[ -r ~/.bashrc ]] && . ~/.bashrc


if [[ $(uname) == 'Linux' ]]; then
    if [ -f ~/.ssh_agent_start.sh ]; then
        . ~/.ssh_agent_start.sh
    fi
fi


# don't run these things if calling perl from BBEdit, it's pretty slow
parent_caller=$(ps -o comm= $PPID)
if [[ -z "$parent_caller" ]] || ! [[ "$parent_caller" =~ BBEdit$ ]]; then
    . $HOME/.bash_aliases
    . $HOME/.git-completion.bash
    . $HOME/.hub-completion.bash
    . $HOME/.knife-completion.bash
    . $HOME/.git.bash
    . $HOME/.bash_prompt
    test -e "${HOME}/.git_local"                        && source "${HOME}/.git_local"
    test -e "${HOME}/.bash_local"                       && source "${HOME}/.bash_local"
    test -e "${HOME}/.iterm2_shell_integration.bash"    && source "${HOME}/.iterm2_shell_integration.bash"
    test -e "${HOME}/.ssh-completion.bash"              && source "${HOME}/.ssh-completion.bash"
    test -e "${HOME}/.shiftboard_api_completion.sh"     && source "${HOME}/.shiftboard_api_completion.sh"
    test -e "${HOME}/.shiftboard_tool_completion.sh"    && source "${HOME}/.shiftboard_tool_completion.sh"

    complete -C '/usr/local/bin/aws_completer' aws

    if [[ -r "$HOME/.smartcd_config" ]]; then
        . ~/.smartcd_config
    fi
fi

true


function set_iterm_profile {
    export OLD_ITERM_PROFILE=$ITERM_PROFILE
    _set_iterm_profile "$1"
}

function reset_iterm_profile {
    if [[ -z "$OLD_ITERM_PROFILE" ]]; then
        OLD_ITERM_PROFILE=$ITERM_PROFILE
    fi
    _set_iterm_profile "$OLD_ITERM_PROFILE"
}

function _set_iterm_profile {
    echo -e "\033]50;SetProfile=${1}\a"
}
