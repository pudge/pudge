#. $HOME/.marchex_github_token
#export GITHUB_HOST=github.marchex.com

#github_team_id () {
#    local team_name=$1
#    github_api /orgs/marchex/teams | jq -r -c ".[] | select(.slug == \"${team_name}\") | .id"
#}
# 
# github_mail () {
#     curl -s -L -u cnandor:$MARCHEX_GITHUB_TOKEN \
#         https://github.marchex.com/stafftools/reports/all_users.csv | \
#         egrep -v ',email,|chef-delivery|tools-automation' | \
#         sort -t, -k3 | \
#         perl -F, -ane 'print "$F[3]," unless $F[5] eq "true"'
#         xargs -IMAILS open_url 'mailto:MAILS'
# 
# #     github_api /users | \
# #         jq '.[] | select(.type == "User") | select(.login != "ghost") | select(.login != "chef-delivery") | select(.login != "tools-automation") | .login' | \
# #         xargs -IUSER github_api /users/USER | \
# #         jq -r 'select(.suspended_at == null) | .login' | \
# #         sort | \
# #         perl -pe 'chomp; $_="$_\@marchex.com,"' | \
# #         xargs -IMAILS open_url 'mailto:MAILS'
# }
