if [[ $(uname) == 'Darwin' ]]; then
    alias ll="ls -lhG"
    alias ls="ls -G"
    alias verbosemode='sudo nvram boot-args="-v"'
    # https://support.apple.com/en-us/HT202516
    alias dnsflush='sudo bash -c "dscacheutil -flushcache && killall -HUP mDNSResponder"'
    alias markoff='open -a Markoff'
    alias dfh="df -PhY -T nodevfs,autofs,nullfs | grep -v '/(System|Library/Developer/CoreSimulator)/Volumes/[^/]+$'"
else
    alias ll="ls -lh --color"
    alias ls="ls --color"
    alias dfh="df -PhT -x squashfs -x tmpfs -x devtmpfs"
fi

alias cl=clear
alias grep="egrep --color"
# alias whois="whois -h whois.geektools.com"
alias cenodiff="cenoview -l diff.diff"
alias tmfixenv='$HOME/bin/tmfixenv.pl > $HOME/.tmfixenv;source $HOME/.tmfixenv'
alias fucking=sudo
alias tcpd='sudo tcpdump -p -i any -s0 -v -w /tmp/$(hostname).$(date +%F-%T).pcap'
# if [[ -x `which hub` ]]; then
#     alias git=hub
# fi

alias tmcc='tmux -CC'
alias tmca='tmux -CC attach'

alias dr='direnv reload'

alias dockrun='docker run -it --rm'

if [[ $(uname) == 'Linux' ]] && [[ $(which kubectl 2>/dev/null) ]]; then
    alias kc=kubectl

    source <(kubectl completion bash)
    if [[ $(type -t compopt) = "builtin" ]]; then
        complete -o default -F __start_kubectl kc
    else
        complete -o default -o nospace -F __start_kubectl kc
    fi

fi

function kce() {
    cmd=$2
    container_id=$(kubectl get po | grep $1 | grep Running | cut -f 1 -d ' ' | head -1)
    if [[ -z $container_id ]]; then
        echo "could not find container ID for $1"
    else
        echo -e "trying to log into $container_id to exec $cmd ...\n"
        kubectl exec -it $container_id -- $cmd
    fi
}
function kcb() {
    kce $1 bash
}

function tt() {
    track_time "$@"
}
export -f tt

function jb() {
    jira_branch "$@"
}
export -f jb

function jo() {
    jira_open "$@"
}
export -f jo

function ji() {
    jira_id "$@"
}
export -f ji

alias cs=complete-shell

function psg() {
    ps auxww | egrep --color=always $1 | egrep --color=never -v ' (egrep|grep -E) '
}
export -f psg

#alias sshc="source $HOME/.ssh/env"

function git_only() {
    opts=$(git rev-parse --no-revs "$@" 2>/dev/null)
    rev=$(git rev-parse --revs-only "$@" 2>/dev/null)
    if [[ -z $rev ]]; then
        branch=$(git name-rev --name-only HEAD)
    else
        branch=$rev
    fi
    git log $(git rev-parse --not --remotes --branches | grep -v $(git rev-parse $branch)) $branch $opts
}
