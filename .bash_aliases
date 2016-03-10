if [[ $(uname) == 'Darwin' ]]; then
    alias ll="ls -lhG"
    alias verbosemode='sudo nvram boot-args="-v"'
    alias dnsflush='sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder'
else
    alias ll="ls -lh --color"
fi

alias grep="egrep --color"
alias whois="whois -h whois.geektools.com"
alias cenodiff="cenoview -l foo.diff"
alias fixenv='$HOME/bin/fixenv.pl > $HOME/.fixenv;source $HOME/.fixenv'
alias fucking=sudo
alias tcpd='sudo tcpdump -p -i any -s0 -v -w /tmp/$(hostname).$(date +%F-%T).pcap'
eval "$(hub alias -s)"

function psg {
    ps auxww | egrep --color=always $1 | egrep --color=never -v egrep
}

function git_only {
    opts=$(git rev-parse --no-revs "$@" 2>/dev/null)
    rev=$(git rev-parse --revs-only "$@" 2>/dev/null)
    if [[ -z $rev ]]; then
        branch=$(git name-rev --name-only HEAD)
    else
        branch=$rev
    fi
    git log $(git rev-parse --not --remotes --branches | grep -v $(git rev-parse $branch)) $branch $opts
}
export -f git_only

