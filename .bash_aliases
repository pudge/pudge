if [[ $(uname) == 'Darwin' ]]; then
    alias ll="ls -lhG"
    alias ls="ls -G"
    alias verbosemode='sudo nvram boot-args="-v"'
    # https://support.apple.com/en-us/HT202516
    alias dnsflush='sudo killall -HUP mDNSResponder'
    alias markoff='open -a Markoff'
else
    alias ll="ls -lh --color"
    alias ls="ls --color"
fi

vg() {
    vagrant "$@"
}
export -f vg

myup() {
    sudo mysql.server start "$@"
    #sudo /usr/local/mariadb/server/support-files/mysql.server start "$@"
}
export -f myup

mydown() {
    sudo mysql.server stop "$@"
    #sudo /usr/local/mariadb/server/support-files/mysql.server stop "$@"
}
export -f mydown

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

ap() {
    ansible-playbook -v --skip-tags=vault -i $ANSIBLE_HOME/inventory $ANSIBLE_HOME/site.yml --limit "$@"
}
export -f ap

apv() {
    ansible-playbook -v --ask-vault-pass -i $ANSIBLE_HOME/inventory $ANSIBLE_HOME/site.yml --limit "$@"
}
export -f apv


alias sb_db='sudo MYSQL_PWD=$(sudo /opt/bin/secret MYSQL_LOCALHOST_ROOT) mysql -u root shiftboard_com_2'
tail_servola() {
    sudo tail -n 100 -F /var/log/shiftboard/*log /var/log/attestations/*log /var/log/apache2/*log /var/log/notify/*log /var/log/slate/*log /var/log/frontdoor/*log "$@"
}
export -f tail_servola


alias com2_master=' MYSQL_PS1="com2/MASTER> "  MYSQL_PWD=$(sudo /opt/bin/secret DBPASS_shiftboard_com_2)        mysql --pager=less --init-command BEGIN -h sqldb -u shiftboard_com_2 shiftboard_com_2'
alias com2_script=' MYSQL_PS1="com2/SCRIPT> "  MYSQL_PWD=$(sudo /opt/bin/secret DBPASS_shiftboard_com_2)        mysql --pager=less                      -h sqldb -u shiftboard_com_2 shiftboard_com_2'
alias com2_ro='     MYSQL_PS1="com2/ro> "      MYSQL_PWD=$(sudo /opt/bin/secret DBPASS_readonly)            mysql --pager=less                      -h sqldb -u readonly         shiftboard_com_2'

alias sb_dbs_rm="rm -rf /opt/dump/scrubbed/*; bash $SB/ansible/roles/servola_db/files/db_refresh --no-log --sync-only"
alias sb_dbs="bash $SB/ansible/roles/servola_db/files/db_refresh --no-log --sync-only"
alias sb_dbr="bash $SB/ansible/roles/servola_db/files/db_refresh --no-log --refresh-only"
alias sb_dbf="bash $SB/ansible/roles/servola_db/files/db_refresh --no-log"
tt() {
    track_time "$@"
}
export -f tt

jb() {
    jira_branch "$@"
}
export -f jb

jo() {
    jira_open "$@"
}
export -f jo

ji() {
    jira_id "$@"
}
export -f ji

alias cs=complete-shell
alias api_client=$SB/app/tools/api_client.pl

psg() {
    ps auxww | egrep --color=always $1 | egrep --color=never -v egrep
}
export -f psg

knife_hosted() {
    knife "$@" --config ~/.chef/knife-hosted.rb
}

knife_ent() {
    knife "$@" --config ~/.chef/knife-ent.rb
}

knife_prem() {
    knife "$@" --config ~/.chef/knife-prem.rb
}

git_only() {
    opts=$(git rev-parse --no-revs "$@" 2>/dev/null)
    rev=$(git rev-parse --revs-only "$@" 2>/dev/null)
    if [[ -z $rev ]]; then
        branch=$(git name-rev --name-only HEAD)
    else
        branch=$rev
    fi
    git log $(git rev-parse --not --remotes --branches | grep -v $(git rev-parse $branch)) $branch $opts
}

mfa() {
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN

    read -e -p 'MFA Code: ' mfa_code

    session=$(aws sts get-session-token --serial-number arn:aws:iam::869546935036:mfa/chris.nandor --token-code $mfa_code --duration-seconds 86400)

    export AWS_ACCESS_KEY_ID=$(echo $session | jq '.Credentials.AccessKeyId' | tr -d \")
    export AWS_SECRET_ACCESS_KEY=$(echo $session | jq '.Credentials.SecretAccessKey' | tr -d \")
    export AWS_SESSION_TOKEN=$(echo $session | jq '.Credentials.SessionToken' | tr -d \")
}
