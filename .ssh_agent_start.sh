# this script will start up an agent if it doesn't already exist, and
# add any *dsa or *rsa keys to it that it can find in $HOME/.ssh.  it
# saves the agent info, and if the saved ssh-agent is already running,
# new logins will simply connect to it, so there's not hundreds of agents
# lying around. and you only have to enter your password once per agent.

# this will not run under tmux; hopefully, it ran before you ran tmux and
# inherited the environment

if [ $EUID -ne 0 ] && [ $(ps -p $(ps -p $$ -o ppid=) -o ucmd=) != "tmux" ] ; then
    unset SSH_AGENT_PID
    SSH_ENV="$HOME/.ssh/environment"

    function start_agent {
        echo "Initializing new SSH agent..."
        /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
        echo "succeeded"
        chmod 600 "${SSH_ENV}"
        . "${SSH_ENV}" > /dev/null
        # add new keys
        /usr/bin/ssh-add ${HOME}/.ssh/{identity,*dsa,*rsa,${USER}} 2>/dev/null
    }

    # Source SSH settings, if applicable
    if [ -f "${SSH_ENV}" ]; then
        . "${SSH_ENV}" > /dev/null

        # if no saved PID, or agent not found with saved PID, or agent doesn't have any keys ... start a new one
        if [ -z "${SSH_AGENT_PID}" ] ||
           [ $(ps -p ${SSH_AGENT_PID} | grep ssh-agent$ | wc -l) -eq 0 ] ||
           [ $(ssh-add -l 2>/dev/null | grep '^[0-9]' | wc -l) -eq 0 ]; then
            start_agent;
        fi
    else
        start_agent;
    fi
fi
