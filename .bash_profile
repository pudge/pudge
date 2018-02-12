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

export SB=$HOME/src/shiftboard

export GITHUB_HOST=github.com

if [[ $(uname) == 'Linux' ]]; then
    ulimit -n 4096
    export EDITOR=vim
    if [[ -d /home/vagrant ]]; then
        export EDITOR=ceno
    fi

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
    MYPATH=$PATH:/usr/local/mariadb/server/bin:/usr/local/src/marchex/marchex/bin

    export COPY_EXTENDED_ATTRIBUTES_DISABLE=1
    export COPYFILE_DISABLE=1
    export VERSIONER_PERL_PREFER_32_BIT=yes
    unset AEDebug AEDebugSends AEDebugReceives AEDebugVerbose AEDebugOSL
fi

export PATH=$HOME/bin:$MYPATH:$HOME/.yarn/bin

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
test -e "${HOME}/.ssh-completion.bash" && source "${HOME}/.ssh-completion.bash"
test -e "${HOME}/.shiftboard_api_completion.sh" && source "${HOME}/.shiftboard_api_completion.sh"
true


##
# Your previous /Users/chris.nandor/.bash_profile file was backed up as /Users/chris.nandor/.bash_profile.macports-saved_2017-05-06_at_21:49:41
##

# MacPorts Installer addition on 2017-05-06_at_21:49:41: adding an appropriate PATH variable for use with MacPorts.
#export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.
