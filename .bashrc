#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

function git_entry {
    git status 2>/dev/null 1>&2
    if [[ "$?" = "0" ]]; then
        branch=$(git status 2>/dev/null | grep "On branch" | awk '{print $3}')
        echo -n " [$branch]"
    fi
}

green='\e[1;32m'
PS1="[\u@\h \W]\`git_entry\` \$ "
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=5000
