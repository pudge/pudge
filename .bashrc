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

export PATH=$HOME/bin:/opt/bin:$MYPATH:$HOME/.yarn/bin
