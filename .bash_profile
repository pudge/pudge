umask 0002
ulimit -n 2048

shopt -s histappend
export HISTFILESIZE=1000000
export HISTSIZE=1000000
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT='%F %T '

export OPEN_URL_SSH=1
export SITE=/site
export DEV_ID=2
export TNS_ADMIN=$HOME

if [[ $(uname) == 'Linux' ]]; then
    export EDITOR=vim

    if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
        . /etc/bash_completion
    elif [ -f /etc/bash_completion.d/marchex_log ] && ! shopt -oq posix; then
        . /etc/bash_completion.d/marchex_log
    fi

    if [[ $(hostname) == 'grax.sea' ]]; then
        if [ -f /site/marchex/etc/profile.d/40-ssh_agent_start.sh ]; then
            . /site/marchex/etc/profile.d/40-ssh_agent_start.sh
        fi

        if [ -f /site/src/ansible/hacking/env-setup ]; then
            . /site/src/ansible/hacking/env-setup -q
        fi

        export JAVA_HOME=$SITE/jdk/jdk1.7.0_67
        export PATH=$JAVA_HOME/bin:$PATH
    else
        renice +1 $$
    fi

elif [[ $(uname) == 'Darwin' ]]; then
    unset AEDebug AEDebugSends AEDebugReceives AEDebugVerbose AEDebugOSL
    export EDITOR=bbeditw
    export PATH=/usr/local/src/marchex/marchex/bin/:$PATH
    export COPY_EXTENDED_ATTRIBUTES_DISABLE=1
    export COPYFILE_DISABLE=1
    export VERSIONER_PERL_PREFER_32_BIT=yes
fi

export PATH=$HOME/bin:/site/marchex/bin:/opt/chef/embedded/bin:$PATH

. $HOME/.bash_aliases
. $HOME/.bash_prompt
. $HOME/.git-completion.bash
. $HOME/.knife-completion.bash


if [[ -r "$HOME/.smartcd_config" ]]; then
    . ~/.smartcd_config
fi
