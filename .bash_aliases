if [[ $(uname) == 'Darwin' ]]; then
    alias ll="ls -lhG"
    alias ls="ls -G"
    alias verbosemode='sudo nvram boot-args="-v"'
    # https://support.apple.com/en-us/HT202516
    alias dnsflush='sudo killall -HUP mDNSResponder'
    alias markoff='open -a Markoff'
    alias dfh="df -PhT apfs | grep -v '/(VM|Preboot|Update)$' | grep -v ' /$' | grep -v '/private/var/vm'"
else
    alias ll="ls -lh --color"
    alias ls="ls --color"
    alias dfh="df -Phl -x squashfs -x tmpfs -x devtmpfs"
fi

alias grep="egrep --color"
alias whois="whois -h whois.geektools.com"
alias cenodiff="cenoview -l foo.diff"
alias fixenv='$HOME/bin/fixenv.pl > $HOME/.fixenv;source $HOME/.fixenv'
alias fucking=sudo
alias tcpd='sudo tcpdump -p -i any -s0 -v -w /tmp/$(hostname).$(date +%F-%T).pcap'
if [[ -x `which hub` ]]; then
    alias git=hub
fi
alias ssg='ssh grax.sea.marchex.com'
# alias be='bundle exec'
# alias bkitchen='bundle exec kitchen'
# alias b2kitchen='KITCHEN_YAML=.kitchen.ec2.yml bundle exec kitchen'
# alias gcg=github_changelog_generator
# alias gcgm='github_changelog_generator --github-site="https://github.marchex.com" --github-api="https://github.marchex.com/api/v3"'

function ap() {
    _fix_ap_hosts $1
    shift
    ansible-playbook -v --skip-tags=vault -i $ANSIBLE_HOME/inventory $ANSIBLE_HOME/site.yml --limit "$ap_hosts" "$@"
}
export -f ap

function apv() {
    _fix_ap_hosts $1
    shift
    ansible-playbook -v --ask-vault-pass -i $ANSIBLE_HOME/inventory $ANSIBLE_HOME/site.yml --limit "$ap_hosts" "$@"
}
export -f apv

function _fix_ap_hosts() {
    arg=$1
    export AP_ENV=$(get_env.sh)
    ap_hosts=$(perl -e '@a=split /\s*,\s*/, shift; for (@a) { $_ .= ".$ENV{AP_ENV}" unless /[.&:]/ }; print join ",", @a' "$arg")
}

alias sb_db='sudo MYSQL_PWD=$(sudo /opt/bin/secret MYSQL_LOCALHOST_ROOT) mysql -u root shiftboard_com_2'

if [[ $(alias tail_servola 2>/dev/null) ]]; then
    unalias tail_servola
fi

function tail_servola() {
    sudo tail -n 100 -F /var/log/shiftboard/*log /var/log/attestations/*log /var/log/apache2/*log /var/log/notify/*log /var/log/slate/*log /var/log/frontdoor/*log /var/log/mapp/*log "$@"
}

vg() {
    vagrant "$@"
}
export -f vg

myup() {
    mysql.server start "$@"
    #sudo /usr/local/mariadb/server/support-files/mysql.server start "$@"
}
export -f myup

mydown() {
    mysql.server stop "$@"
    #sudo /usr/local/mariadb/server/support-files/mysql.server stop "$@"
}
export -f mydown

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
alias api_client=$SB/app/tools/api_client.pl

function psg() {
    ps auxww | egrep --color=always $1 | egrep --color=never -v ' (egrep|grep -E) '
}
export -f psg

function knife_hosted() {
    knife "$@" --config ~/.chef/knife-hosted.rb
}

function knife_ent() {
    knife "$@" --config ~/.chef/knife-ent.rb
}

function knife_prem() {
    knife "$@" --config ~/.chef/knife-prem.rb
}

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

if [[ -r "${HOME}/.sb_aliases" ]]; then
    source "${HOME}/.sb_aliases"
fi
