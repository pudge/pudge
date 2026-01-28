shopt -s histappend
shopt -s direxpand 2>/dev/null

export HISTFILESIZE=
export HISTSIZE=
export HISTCONTROL=ignoredups:erasedups:ignorespace
export HISTTIMEFORMAT='%F %T '

export OPEN_URL_SSH=1

export GITHUB_HOST=github.com
export PAGER=less
export FORCE_HYPERLINKS=1

export PIPENV_VENV_IN_PROJECT=true

# Dracula 0
#export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
# Dracula 1
#export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#22212C,hl:#7970A9 --color=fg+:#f8f8f2,bg+:#454158,hl+:#7970A9 --color=info:#ffca80,prompt:#8aff80,pointer:#ff80bf --color=marker:#ffff80,spinner:#9580ff,header:#7970A9'
# Dracula 2
export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#21262c,hl:#9580FF --color=fg+:#f8f8f2,bg+:#414d58,hl+:#9580FF --color=info:#ffca80,prompt:#8aff80,pointer:#ff80bf --color=marker:#ffff80,spinner:#9580ff,header:#708ca9'

if [[ $(uname) == 'Linux' ]]; then
    ulimit -n 4096
    export EDITOR=vim
    MYPATH=$PATH

    if [[ -x "$HOME/bin/url" ]]; then
        export BROWSER="$HOME/bin/url"
    fi

    # renice +1 $$

elif [[ $(uname) == 'Darwin' ]]; then
    export EDITOR=bbeditw
    MYPATH=$PATH:/usr/local/mariadb/server/bin

    export COPY_EXTENDED_ATTRIBUTES_DISABLE=1
    export COPYFILE_DISABLE=1
    export VERSIONER_PERL_PREFER_32_BIT=yes
    #unset AEDebug AEDebugSends AEDebugReceives AEDebugVerbose AEDebugOSL

    if [[ -e ~/.1password/agent.sock ]]; then
        export SSH_AUTH_SOCK=~/.1password/agent.sock
    fi
fi

if [[ $(uname) == 'Linux' ]]; then
    if [[ -x $(which ceno 2>&1 /dev/null) ]]; then
        export EDITOR=ceno
    fi
fi

# don't run these things if calling perl from BBEdit, it's pretty slow
parent_caller=""
if [[ "${PPID}" -ne 0 ]]; then
    parent_caller=$(ps -o comm= $PPID)
fi
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

    test -r "${HOME}/.bash-preexec.sh"                          && source "${HOME}/.bash-preexec.sh"

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

function iterm2_print_user_vars {
#     if [[ -x /opt/bin/get_env.sh ]]; then
#         local myenv=$(/opt/bin/get_env.sh)
#         # \(user.hostname_short)
#         if [[ ! -z "$myenv" && "$myenv" != "unknown" ]]; then
#             iterm2_set_user_var hostname_short $( echo -n "$myenv" )
#         #else
#             #iterm2_set_user_var hostname_short $( echo -n "$(hostname)" )
#         fi
#     fi
    it2git
}

function tmux_env_refresh {
    if [ -n "$TMUX" ]; then
        export SSH_AUTH_SOCK="$(tmux show-environment | grep '^SSH_AUTH_SOCK' | cut -d '=' -f 2)"
        export SSH_CLIENT="$(tmux show-environment | grep '^SSH_CLIENT' | cut -d '=' -f 2)"
        export SSH_CONNECTION="$(tmux show-environment | grep '^SSH_CONNECTION' | cut -d '=' -f 2)"
    fi
}

function preexec {
    tmux_env_refresh
}

if [[ ! -z $(which pyenv) ]]; then
    eval "$(pyenv init -)"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=$HOME/bin:$HOME/.tfenv/bin:$HOME/.local/bin:/opt/bin:/opt/homebrew/bin:$MYPATH:$HOME/.yarn/bin
test -r "${HOME}/.bashrc.local" && source "${HOME}/.bashrc.local"
