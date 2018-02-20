if [[ $(uname) == 'Darwin' ]]; then
    alias ll="ls -lhG"
    alias verbosemode='sudo nvram boot-args="-v"'
    # https://support.apple.com/en-us/HT202516
    alias dnsflush='sudo killall -HUP mDNSResponder'
    alias markoff='open -a Markoff'
else
    alias ll="ls -lh --color"
fi

alias vg=vagrant
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
alias be='bundle exec'
alias bkitchen='bundle exec kitchen'
alias b2kitchen='KITCHEN_YAML=.kitchen.ec2.yml bundle exec kitchen'
alias gcg=github_changelog_generator
alias gcgm='github_changelog_generator --github-site="https://github.marchex.com" --github-api="https://github.marchex.com/api/v3"'

alias ap='ansible-playbook -v --skip-tags=vault -i /opt/shiftboard/ansible/hosts /opt/shiftboard/ansible/site.yml --limit servolabox'
alias sb_db='sudo MYSQL_PWD=$(sudo /opt/bin/secret MYSQL_LOCALHOST_ROOT) mysql -u root shiftboard_com_2'
alias tail_servola="sudo tail -n0 -F /var/log/shiftboard/*log /var/log/apache2/*log"
alias ops_update="git -C /git/ops/ pull --ff-only"

alias sb_dbs="bash $SB/ansible/roles/servola_db/files/db_refresh --sync-only"
alias sb_dbr="bash $SB/ansible/roles/servola_db/files/db_refresh --refresh-only"
alias sb_dbf="bash $SB/ansible/roles/servola_db/files/db_refresh"

function psg {
    ps auxww | egrep --color=always $1 | egrep --color=never -v egrep
}

function knife_hosted {
    knife "$@" --config ~/.chef/knife-hosted.rb
}
export -f knife_hosted

function knife_ent {
    knife "$@" --config ~/.chef/knife-ent.rb
}
export -f knife_ent

function knife_prem {
    knife "$@" --config ~/.chef/knife-prem.rb
}
export -f knife_prem

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
