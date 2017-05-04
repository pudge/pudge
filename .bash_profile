# yes, this is stupid
if ! [[ $(hostname) == 'slugfest.sea' ]]; then

umask 0002

shopt -s histappend
export HISTFILESIZE=1000000
export HISTSIZE=1000000
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT='%F %T '

export OPEN_URL_SSH=1
export SITE=/site
export DEV_ID=2
export TNS_ADMIN=$HOME

export GITHUB_HOST=github.com

if [[ $(uname) == 'Linux' ]]; then
    ulimit -n 4096
    export EDITOR=vim
    MYPATH=/site/devtools/maven/apache-maven-3.0.3/bin/:$PATH:/site/marchex/bin

    if [ -x /site/marchex/bin/open_url ]; then
        export BROWSER=/site/marchex/bin/open_url
    fi

    if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
        . /etc/bash_completion
    elif [ -f /etc/bash_completion.d/marchex_log ] && ! shopt -oq posix; then
        . /etc/bash_completion.d/marchex_log
    fi

    if [[ $(hostname) == 'grax.sea' ]]; then
        export JAVA_HOME=$SITE/jdk/jdk1.7.0_67
        MYPATH=$JAVA_HOME/bin:$MYPATH

    #else
    #    renice +1 $$
    fi

    if [ -f ~/.ssh_agent_start.sh ]; then
        . ~/.ssh_agent_start.sh
    fi

elif [[ $(uname) == 'Darwin' ]]; then
    export EDITOR=bbeditw
    MYPATH=$PATH:/usr/local/src/marchex/marchex/bin

    export COPY_EXTENDED_ATTRIBUTES_DISABLE=1
    export COPYFILE_DISABLE=1
    export VERSIONER_PERL_PREFER_32_BIT=yes
    unset AEDebug AEDebugSends AEDebugReceives AEDebugVerbose AEDebugOSL
fi

export PATH=$HOME/bin:$MYPATH

if [ -f /site/src/ansible/hacking/env-setup ]; then
    . /site/src/ansible/hacking/env-setup -q
fi


# don't run these things if calling perl from BBEdit, it's pretty slow
parent_caller=$(ps -o comm= $PPID)
if [[ -z "$parent_caller" ]] || ! [[ "$parent_caller" =~ BBEdit$ ]]; then
    . $HOME/.bash_aliases
    . $HOME/.git-completion.bash
    . $HOME/.hub-completion.bash
    . $HOME/.knife-completion.bash
    . $HOME/.git.bash
    . $HOME/.git_local
    . $HOME/.bash_prompt

    # this is super-slow, so don't run it unless we need it
#     if ! [[ "$PATH" =~ chefdk ]]; then
#         eval "$(/opt/chefdk/embedded/bin/chef shell-init bash)"
#     fi

    complete -C '/usr/local/bin/aws_completer' aws

    if [[ -r "$HOME/.smartcd_config" ]]; then
        . ~/.smartcd_config
    fi
fi

fi

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
true
