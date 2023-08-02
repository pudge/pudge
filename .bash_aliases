if [[ $(uname) == 'Darwin' ]]; then
    alias ll="ls -lhG"
    alias ls="ls -G"
    alias verbosemode='sudo nvram boot-args="-v"'
    # https://support.apple.com/en-us/HT202516
    alias dnsflush='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
    alias markoff='open -a Markoff'
    alias dfh="df -PhT apfs | grep -v '/(VM|Preboot|Update|/Library/Developer/CoreSimulator/Volumes)$' | grep -v ' /$' | grep -v '/private/var/vm'"
else
    alias ll="ls -lh --color"
    alias ls="ls --color"
    alias dfh="df -Phl -x squashfs -x tmpfs -x devtmpfs"
fi

alias cl=clear
alias grep="egrep --color"
alias whois="whois -h whois.geektools.com"
alias cenodiff="cenoview -l diff.diff"
alias fixenv='$HOME/bin/fixenv.pl > $HOME/.fixenv;source $HOME/.fixenv'
alias fucking=sudo
alias tcpd='sudo tcpdump -p -i any -s0 -v -w /tmp/$(hostname).$(date +%F-%T).pcap'
if [[ -x `which hub` ]]; then
    alias git=hub
fi

alias tmcc='tmux -CC'
alias aws=~/bin/aws_yes_browser

# vg() {
#     vagrant "$@"
# }
# export -f vg
#
# myup() {
#     mysql.server start "$@"
#     #sudo /usr/local/mariadb/server/support-files/mysql.server start "$@"
# }
# export -f myup
#
# mydown() {
#     mysql.server stop "$@"
#     #sudo /usr/local/mariadb/server/support-files/mysql.server stop "$@"
# }
# export -f mydown

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
