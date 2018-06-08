#/bin/bash

comp_ssh_hosts=''
_comp_ssh_hosts ()
{
    comp_ssh_hosts=`test -e ~/.ssh/known_hosts && cat ~/.ssh/known_hosts | \
                    cut -f 1 -d ' ' | \
                    sed -e s/,.*//g | \
                    grep -v ^# | \
                    uniq | \
                    grep -v "\[" ;
            test -e ~/.ssh/config && cat ~/.ssh/config | \
                    grep "^Host " | \
                    awk '{print $2}' | \
                    grep -v '\*'`
}

_complete_ssh_hosts ()
{
    COMPREPLY=()
    local cur=${COMP_WORDS[COMP_CWORD]}
    _comp_ssh_hosts
    COMPREPLY=( $(compgen -W "${comp_ssh_hosts}" -- $cur) )
    return 0
}

# _complete_scp_hosts ()
# {
#     COMPREPLY=()
#     local cur=${COMP_WORDS[COMP_CWORD]}
#     _comp_ssh_hosts
#     COMPREPLY=( $(compgen -W "${comp_ssh_hosts} * .*" -- $cur) )
#     return 0
# }

complete -F _complete_ssh_hosts ssh scp
