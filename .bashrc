shopt -s histappend
shopt -s direxpand

export HISTFILESIZE=100000
export HISTSIZE=100000
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT='%F %T '

export OPEN_URL_SSH=1
export SITE=/site
export DEV_ID=2
export TNS_ADMIN=$HOME

export SB=$HOME/src/shiftboard
export SB_PRISTINE=$HOME/.ghd/src/shiftboard
export ANSIBLE_HOME=$HOME/ansible

export GITHUB_HOST=github.com
export PAGER=less

if [[ $(uname) == 'Linux' ]]; then
    ulimit -n 4096
    export EDITOR=vim
    if [[ -d /home/vagrant ]]; then
        export EDITOR=ceno
    fi

    MYPATH=$PATH

    if [ -x /site/marchex/bin/open_url ]; then
        export BROWSER=/site/marchex/bin/open_url
    fi

    # renice +1 $$

elif [[ $(uname) == 'Darwin' ]]; then
    export EDITOR=bbeditw
    MYPATH=$PATH:/usr/local/mariadb/server/bin

    export COPY_EXTENDED_ATTRIBUTES_DISABLE=1
    export COPYFILE_DISABLE=1
    export VERSIONER_PERL_PREFER_32_BIT=yes
    unset AEDebug AEDebugSends AEDebugReceives AEDebugVerbose AEDebugOSL
fi

export PATH=$HOME/bin:/opt/bin:/opt/homebrew/bin:$MYPATH:$HOME/.yarn/bin

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
    test -r "/opt/homebrew/etc/profile.d/bash_completion.sh"    && source "/opt/homebrew/etc/profile.d/bash_completion.sh"
    test -r "/usr/local/etc/profile.d/bash_completion.sh"       && source "/usr/local/etc/profile.d/bash_completion.sh"

    # brew install git
    test -r "${HOME}/.git-completion.bash"                      && source "${HOME}/.git-completion.bash"
    test -r "${HOME}/.hub-completion.bash"                      && source "${HOME}/.hub-completion.bash"
    test -r "${HOME}/.smartcd_config.sh"                        && source "${HOME}/.smartcd_config.sh"

    # brew install fzf
    test -r "${HOME}/.fzf.bash" && $(which fzf > /dev/null)     && source "${HOME}/.fzf.bash"

#     test -r "${HOME}/.knife-completion.bash"                    && source "${HOME}/.knife-completion.bash"
#     test -r "${HOME}/.ssh-completion.bash"                      && source "${HOME}/.ssh-completion.bash"
#     test -r "${HOME}/.shiftboard_api_completion.sh"             && source "${HOME}/.shiftboard_api_completion.sh"
#     test -r "${HOME}/.shiftboard_tool_completion.sh"            && source "${HOME}/.shiftboard_tool_completion.sh"
    complete -C '/usr/local/bin/aws_completer' aws

    if [[ -r "${HOME}/.complete-shell/src/complete-shell/.rc" ]]; then
        source "${HOME}/.complete-shell/src/complete-shell/.rc"
    fi

    # brew install tmux
    export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=1
    test -r "${HOME}/.iterm2_shell_integration.bash"            && source "${HOME}/.iterm2_shell_integration.bash"
fi

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

# function iterm2_print_user_vars {
#     if [[ -x /opt/bin/get_env.sh ]]; then
#         local myenv=$(/opt/bin/get_env.sh)
#         # \(user.hostname_short)
#         if [[ ! -z "$myenv" && "$myenv" != "unknown" ]]; then
#             iterm2_set_user_var hostname_short $( echo -n "$myenv" )
#         #else
#             #iterm2_set_user_var hostname_short $( echo -n "$(hostname)" )
#         fi
#     fi
# }

if [[ ! -z $(which pyenv) ]]; then
    eval "$(pyenv init -)"
fi
