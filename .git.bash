. $HOME/.marchex_github_token
export GITHUB_HOST=github.marchex.com

github_team_id () {
    local team_name=$1
    github_api /orgs/marchex/teams | jq -r -c ".[] | select(.slug == \"${team_name}\") | .id"
}
