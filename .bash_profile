umask 0002

[[ -r ~/.bashrc ]] && . ~/.bashrc


if [[ $(uname) == 'Linux' ]]; then
    if [ -f ~/.ssh_agent_start.sh ]; then
        . ~/.ssh_agent_start.sh
    fi
fi


# don't run these things if calling perl from BBEdit, it's pretty slow
parent_caller=$(ps -o comm= $PPID)
if [[ -z "$parent_caller" ]] || ! [[ "$parent_caller" =~ /BBEdit\.app/ ]]; then
    # brew install bash; add `/usr/local/bin/bash` to /etc/shells; chsh
    test -r "${HOME}/.bash_aliases"                             && source "${HOME}/.bash_aliases"
    test -r "${HOME}/.bash_prompt"                              && source "${HOME}/.bash_prompt"
    test -r "${HOME}/.git.bash"                                 && source "${HOME}/.git.bash"
    test -r "${HOME}/.git_local"                                && source "${HOME}/.git_local"
    test -r "${HOME}/.bash_local"                               && source "${HOME}/.bash_local"

    # brew install bash-completion@2
    test -r "/usr/local/etc/profile.d/bash_completion.sh"       && source "/usr/local/etc/profile.d/bash_completion.sh"
    # brew install git
    test -r "${HOME}/.git-completion.bash"                      && source "${HOME}/.git-completion.bash"
    test -r "${HOME}/.hub-completion.bash"                      && source "${HOME}/.hub-completion.bash"
    test -r "${HOME}/.smartcd_config.sh"                        && source "${HOME}/.smartcd_config.sh"
    # brew install fzf
    test -r "${HOME}/.fzf.bash"                                 && source "${HOME}/.fzf.bash"

#     test -r "${HOME}/.knife-completion.bash"                    && source "${HOME}/.knife-completion.bash"
#     test -r "${HOME}/.ssh-completion.bash"                      && source "${HOME}/.ssh-completion.bash"
#     test -r "${HOME}/.shiftboard_api_completion.sh"             && source "${HOME}/.shiftboard_api_completion.sh"
#     test -r "${HOME}/.shiftboard_tool_completion.sh"            && source "${HOME}/.shiftboard_tool_completion.sh"
#     complete -C '/usr/local/bin/aws_completer' aws

    if [[ -r "${HOME}/.complete-shell/src/complete-shell/.rc" ]]; then
        source "${HOME}/.complete-shell/src/complete-shell/.rc"
    fi

    # brew install tmux
    export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=1
    test -r "${HOME}/.iterm2_shell_integration.bash"            && source "${HOME}/.iterm2_shell_integration.bash"
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
eval "$(pyenv init -)"
