case "$TERM" in
	screen)
		PS1='[\t] #$WINDOW \u@${HOSTNAME} \[\e[36m\]\!\[\e[0m\] \[\e[35m\]\W\[\e[0m\]\[\e[37m\]$(__git_ps1 " (%s)")\[\e[0m\]\$ '
		;;
	xterm* | rxvt*)
		PS1='[\t] \u@${HOSTNAME%.*.*} \[\e[36m\]\!\[\e[0m\] \[\e[35m\]\W\[\e[0m\]\[\e[37m\]$(__git_ps1 " (%s)")\[\e[0m\]\$ '
		PROMPT_COMMAND='echo -ne "\033];${USER}@${HOSTNAME%.*.*}:${PWD/#$HOME/~} \007"'
		export PROMPT_COMMAND
		;;
	*)
		;;
esac
export PS1

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

export -f git_only
